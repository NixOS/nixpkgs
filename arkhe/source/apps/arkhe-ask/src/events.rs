//! At-least-once outbox transport with a durable idempotent proof projection.
//! No answer, query or claim text is sent to Kafka.
use crate::pipeline::CitationProof;
use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope},
    Digest32,
};
use arkhe_wormgraph::WormGraph;
use async_trait::async_trait;
use rskafka::{
    client::{
        partition::{Compression, OffsetAt, PartitionClient, UnknownTopicHandling},
        ClientBuilder,
    },
    record::Record,
};
use serde::{Deserialize, Serialize};
use sqlx::{PgPool, Postgres, Transaction};
use std::{collections::HashMap, sync::Arc, time::Duration};
use tracing::Instrument;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct VerifiedEvent {
    pub version: u8,
    pub event_id: String,
    pub proof: CitationProof,
}
impl VerifiedEvent {
    pub fn new(proof: CitationProof) -> Self {
        Self {
            version: 1,
            event_id: uuid::Uuid::new_v4().to_string(),
            proof,
        }
    }
    pub fn envelope(&self) -> Result<EvidenceEnvelope, String> {
        if self.version != 1
            || uuid::Uuid::parse_str(&self.event_id).is_err()
            || self.proof.tenant_id.trim().is_empty()
            || self.proof.evidence_ids.is_empty()
        {
            return Err("invalid verified event".into());
        }
        let bytes = serde_json::to_vec(self).map_err(|e| e.to_string())?;
        let hash = Digest32::blake3(b"AKG:ASK:EVENT:v1\0", &bytes);
        Ok(EvidenceEnvelope {
            record_hash: hash,
            kind: "ask.citation.verified.v1".into(),
            subject: self.proof.record_digest,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: vec![],
        })
    }
}

#[async_trait]
pub trait ProofJournal: Send + Sync {
    async fn record(&self, proof: &CitationProof) -> Result<(), String>;
}
#[async_trait]
pub trait EventPublisher: Send + Sync {
    async fn publish(&self, event: &VerifiedEvent) -> Result<(), String>;
}

pub struct PgProofJournal {
    pool: PgPool,
    pub graph: Arc<WormGraph>,
}
impl PgProofJournal {
    pub async fn connect(pool: PgPool) -> Result<Self, String> {
        sqlx::migrate!("./migrations")
            .run(&pool)
            .await
            .map_err(|e| e.to_string())?;
        let graph = Arc::new(WormGraph::new());
        let envelopes: Vec<(serde_json::Value,)> =
            sqlx::query_as("SELECT envelope FROM ask_proof_anchors")
                .fetch_all(&pool)
                .await
                .map_err(|e| e.to_string())?;
        for (value,) in envelopes {
            graph
                .append_verified(serde_json::from_value(value).map_err(|e| e.to_string())?)
                .await?;
        }
        Ok(Self { pool, graph })
    }
    pub fn pool(&self) -> &PgPool {
        &self.pool
    }

    pub async fn enqueue(&self, event: &VerifiedEvent) -> Result<(), String> {
        event.envelope()?;
        let payload = serde_json::to_value(event).map_err(|e| e.to_string())?;
        let result = sqlx::query(
            "INSERT INTO ask_verified_outbox(event_id,tenant_id,payload,trace_context)
            VALUES($1,$2,$3,$4) ON CONFLICT(event_id) DO UPDATE SET event_id=EXCLUDED.event_id
            WHERE ask_verified_outbox.payload=EXCLUDED.payload
                AND ask_verified_outbox.tenant_id=EXCLUDED.tenant_id",
        )
        .bind(&event.event_id)
        .bind(&event.proof.tenant_id)
        .bind(payload)
        .bind(serde_json::to_value(crate::telemetry::capture_context()).map_err(|e| e.to_string())?)
        .execute(&self.pool)
        .await
        .map_err(|e| e.to_string())?;
        if result.rows_affected() != 1 {
            return Err("event id bound to different payload".into());
        }
        Ok(())
    }

    /// The database row stays locked until Kafka acknowledges or the bounded attempt fails.
    #[tracing::instrument(skip_all, name = "arkhe.ask.proof.relay")]
    pub async fn relay_once(&self, publisher: &dyn EventPublisher) -> Result<bool, String> {
        let mut tx = self.pool.begin().await.map_err(|e| e.to_string())?;
        let row: Option<(String, serde_json::Value,serde_json::Value)> = sqlx::query_as(
            "SELECT event_id,payload,trace_context FROM ask_verified_outbox WHERE published_at IS NULL
             ORDER BY created_at,event_id FOR UPDATE SKIP LOCKED LIMIT 1",
        )
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        let Some((id, value, context)) = row else {
            tx.commit().await.map_err(|e| e.to_string())?;
            return Ok(false);
        };
        let event: VerifiedEvent = serde_json::from_value(value).map_err(|e| e.to_string())?;
        let context: HashMap<String, String> =
            serde_json::from_value(context).map_err(|e| e.to_string())?;
        let span = tracing::info_span!(
            "arkhe.ask.proof.publish",
            otel.kind = "producer",
            messaging.system = "kafka"
        );
        crate::telemetry::restore_parent(&span, &context);
        tokio::time::timeout(
            Duration::from_secs(10),
            publisher.publish(&event).instrument(span),
        )
        .await
        .map_err(|_| "Kafka publish timed out")??;
        sqlx::query("UPDATE ask_verified_outbox SET published_at=now() WHERE event_id=$1")
            .bind(id)
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(true)
    }

    async fn apply(
        &self,
        tx: &mut Transaction<'_, Postgres>,
        event: &VerifiedEvent,
    ) -> Result<EvidenceEnvelope, String> {
        let expected: Option<(String, serde_json::Value)> =
            sqlx::query_as("SELECT tenant_id,payload FROM ask_verified_outbox WHERE event_id=$1")
                .bind(&event.event_id)
                .fetch_optional(&mut **tx)
                .await
                .map_err(|e| e.to_string())?;
        let value = serde_json::to_value(event).map_err(|e| e.to_string())?;
        if expected != Some((event.proof.tenant_id.clone(), value.clone())) {
            return Err("Kafka event is not admitted by the verified outbox".into());
        }
        let envelope = event.envelope()?;
        let result = sqlx::query("INSERT INTO ask_proof_anchors(event_id,payload,envelope) VALUES($1,$2,$3)
            ON CONFLICT(event_id) DO UPDATE SET event_id=EXCLUDED.event_id
            WHERE ask_proof_anchors.payload=EXCLUDED.payload AND ask_proof_anchors.envelope=EXCLUDED.envelope")
            .bind(&event.event_id).bind(value).bind(serde_json::to_value(&envelope).map_err(|e| e.to_string())?)
            .execute(&mut **tx).await.map_err(|e| e.to_string())?;
        if result.rows_affected() != 1 {
            return Err("anchor id collision".into());
        }
        Ok(envelope)
    }

    /// Durable cursor and projection commit in the same PostgreSQL transaction.
    /// Poison messages or retention gaps stop this partition; never silently skip.
    #[tracing::instrument(skip_all, name = "arkhe.ask.proof.poll")]
    pub async fn consume_once(&self, bus: &KafkaBus) -> Result<usize, String> {
        sqlx::query(
            "INSERT INTO ask_kafka_cursors(topic,next_offset) VALUES($1,0) ON CONFLICT DO NOTHING",
        )
        .bind(&bus.topic)
        .execute(&self.pool)
        .await
        .map_err(|e| e.to_string())?;
        let mut tx = self.pool.begin().await.map_err(|e| e.to_string())?;
        let (offset,): (i64,) =
            sqlx::query_as("SELECT next_offset FROM ask_kafka_cursors WHERE topic=$1 FOR UPDATE")
                .bind(&bus.topic)
                .fetch_one(&mut *tx)
                .await
                .map_err(|e| e.to_string())?;
        let earliest = tokio::time::timeout(
            Duration::from_secs(10),
            bus.partition.get_offset(OffsetAt::Earliest),
        )
        .await
        .map_err(|_| "Kafka offset timed out")?
        .map_err(|e| e.to_string())?;
        if offset < earliest {
            return Err("Kafka retention gap; manual replay required".into());
        }
        let (records, _) = tokio::time::timeout(
            Duration::from_secs(10),
            bus.partition.fetch_records(offset, 1..1_048_576, 100),
        )
        .await
        .map_err(|_| "Kafka fetch timed out")?
        .map_err(|e| e.to_string())?;
        let mut next = offset;
        let mut envelopes = Vec::new();
        for record in &records {
            let raw = record
                .record
                .value
                .as_ref()
                .ok_or("Kafka tombstone is not a proof event")?;
            let event: VerifiedEvent = serde_json::from_slice(raw).map_err(|e| e.to_string())?;
            if record.record.key.as_deref() != Some(event.event_id.as_bytes()) {
                return Err("Kafka key and event id differ".into());
            }
            let context: HashMap<String, String> = record
                .record
                .headers
                .iter()
                .filter(|(k, v)| {
                    matches!(k.as_str(), "traceparent" | "tracestate") && v.len() <= 512
                })
                .filter_map(|(k, v)| String::from_utf8(v.clone()).ok().map(|v| (k.clone(), v)))
                .collect();
            let consumer = tracing::info_span!(
                "arkhe.ask.proof.consume",
                otel.kind = "consumer",
                messaging.system = "kafka"
            );
            crate::telemetry::restore_parent(&consumer, &context);
            let anchor = tracing::info_span!(parent:&consumer,"arkhe.ask.proof.anchor");
            let envelope = self
                .apply(&mut tx, &event)
                .instrument(anchor.clone())
                .await?;
            envelopes.push((envelope, consumer, anchor));
            next = record
                .offset
                .checked_add(1)
                .ok_or("Kafka offset overflow")?;
        }
        sqlx::query("UPDATE ask_kafka_cursors SET next_offset=$2 WHERE topic=$1")
            .bind(&bus.topic)
            .bind(next)
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        for (envelope, _consumer, _anchor) in envelopes {
            self.graph.append_verified(envelope).await?;
        }
        Ok(records.len())
    }
}
#[async_trait]
impl ProofJournal for PgProofJournal {
    async fn record(&self, proof: &CitationProof) -> Result<(), String> {
        self.enqueue(&VerifiedEvent::new(proof.clone())).await
    }
}

pub struct KafkaBus {
    pub topic: String,
    pub partition: Arc<PartitionClient>,
}
impl KafkaBus {
    /// Topic provisioning is deployment-owned: one partition, no consumer-group offsets.
    pub async fn connect(brokers: Vec<String>, topic: String) -> Result<Self, String> {
        let partition = tokio::time::timeout(Duration::from_secs(10), async {
            let client = ClientBuilder::new(brokers)
                .build()
                .await
                .map_err(|e| e.to_string())?;
            client
                .partition_client(topic.clone(), 0, UnknownTopicHandling::Error)
                .await
                .map_err(|e| e.to_string())
        })
        .await
        .map_err(|_| "Kafka connection timed out")??;
        Ok(Self {
            topic,
            partition: Arc::new(partition),
        })
    }
}
#[async_trait]
impl EventPublisher for KafkaBus {
    async fn publish(&self, event: &VerifiedEvent) -> Result<(), String> {
        let record = Record {
            key: Some(event.event_id.as_bytes().to_vec()),
            value: Some(serde_json::to_vec(event).map_err(|e| e.to_string())?),
            headers: crate::telemetry::capture_context()
                .into_iter()
                .map(|(k, v)| (k, v.into_bytes()))
                .collect(),
            timestamp: rskafka::chrono::Utc::now(),
        };
        self.partition
            .produce(vec![record], Compression::NoCompression)
            .await
            .map_err(|e| e.to_string())?;
        Ok(())
    }
}
