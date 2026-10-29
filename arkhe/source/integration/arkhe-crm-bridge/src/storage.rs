use crate::v2::{self, Bundle, Checkpoint, Policy, Request};
use anyhow::{ensure, Context, Result};
use arkhe_verify_core::mmr::build_root_and_proof;
use ed25519_dalek::SigningKey;
use rusqlite::{params, Connection, OptionalExtension, TransactionBehavior};
use std::{path::Path, time::Duration};

pub struct Store {
    connection: Connection,
}
impl Store {
    pub fn open(path: &Path) -> Result<Self> {
        let connection = Connection::open(path)?;
        connection.busy_timeout(Duration::from_secs(10))?;
        connection.pragma_update(None, "journal_mode", "WAL")?;
        connection.pragma_update(None, "synchronous", "FULL")?;
        connection.execute_batch(
            "CREATE TABLE IF NOT EXISTS bridge_meta (
                singleton INTEGER PRIMARY KEY CHECK(singleton=1), policy_hash TEXT NOT NULL);
             CREATE TABLE IF NOT EXISTS bridge_events (
                sequence INTEGER PRIMARY KEY, event_id TEXT NOT NULL UNIQUE,
                event_hash TEXT NOT NULL, bundle TEXT NOT NULL);",
        )?;
        Ok(Self { connection })
    }
    /// Commit event, replay key and response atomically; exact retries return the saved response.
    pub fn anchor(
        &mut self,
        request: Request,
        policy: &Policy,
        key: &SigningKey,
        now: u64,
    ) -> Result<Bundle> {
        request.authenticate(policy)?;
        ensure!(
            v2::public_key(key) == policy.bridge_public_key,
            "wrong bridge signing key"
        );
        let policy_hash = policy.hash()?;
        let event_hash = request.event.hash()?;
        let tx = self
            .connection
            .transaction_with_behavior(TransactionBehavior::Immediate)?;
        let pinned: Option<String> = tx
            .query_row(
                "SELECT policy_hash FROM bridge_meta WHERE singleton=1",
                [],
                |r| r.get(0),
            )
            .optional()?;
        if let Some(pinned) = pinned {
            ensure!(
                pinned == policy_hash,
                "policy migration requires explicit separate procedure"
            );
        } else {
            tx.execute("INSERT INTO bridge_meta VALUES (1, ?1)", [&policy_hash])?;
        }
        let mut leaves = Vec::new();
        let mut previous = "00".repeat(32);
        let mut last_time = 0;
        let mut retry = None;
        {
            let mut statement = tx.prepare("SELECT sequence, event_id, event_hash, bundle FROM bridge_events ORDER BY sequence")?;
            let rows = statement.query_map([], |r| {
                Ok((
                    r.get::<_, u64>(0)?,
                    r.get::<_, String>(1)?,
                    r.get::<_, String>(2)?,
                    r.get::<_, String>(3)?,
                ))
            })?;
            for row in rows {
                let (sequence, id, hash, json) = row?;
                let saved: Bundle = serde_json::from_str(&json)?;
                v2::verify(&saved, policy)?;
                ensure!(
                    sequence == leaves.len() as u64 + 1 && saved.checkpoint.leaf_count == sequence,
                    "journal sequence mismatch"
                );
                ensure!(
                    saved.request.event.event_id == id && saved.record_hash == hash,
                    "journal identity mismatch"
                );
                ensure!(
                    saved.checkpoint.previous_checkpoint_hash == previous
                        && saved.checkpoint.issued_at >= last_time,
                    "broken checkpoint chain"
                );
                leaves.push(v2::bytes32(&hash)?.to_vec());
                let (root, _) = build_root_and_proof(&leaves, leaves.len() - 1)?;
                ensure!(
                    hex::encode(root) == saved.checkpoint.root,
                    "journal root mismatch"
                );
                previous = saved.checkpoint.hash()?;
                last_time = saved.checkpoint.issued_at;
                if id == request.event.event_id {
                    ensure!(
                        hash == event_hash && saved.request.signature == request.signature,
                        "replay conflict: event_id already used"
                    );
                    retry = Some(saved);
                }
            }
        }
        if let Some(bundle) = retry {
            tx.commit()?;
            return Ok(bundle);
        }
        request.fresh_at(policy, now)?;
        ensure!(now >= last_time, "bridge clock moved backwards");
        leaves.push(v2::bytes32(&event_hash)?.to_vec());
        let (root, proof) = build_root_and_proof(&leaves, leaves.len() - 1)?;
        let checkpoint = Checkpoint {
            schema: 2,
            log_id: policy.log_id.clone(),
            root: hex::encode(root),
            leaf_count: leaves.len() as u64,
            previous_checkpoint_hash: previous,
            issued_at: now,
            policy_hash,
        };
        let checkpoint_signature = checkpoint.sign(key)?;
        let bundle = Bundle {
            schema: 2,
            request,
            record_hash: event_hash,
            checkpoint,
            checkpoint_signature,
            proof,
        };
        v2::verify(&bundle, policy)?;
        tx.execute(
            "INSERT INTO bridge_events VALUES (?1, ?2, ?3, ?4)",
            params![
                bundle.checkpoint.leaf_count,
                bundle.request.event.event_id,
                bundle.record_hash,
                serde_json::to_string(&bundle)?
            ],
        )?;
        tx.commit()?;
        Ok(bundle)
    }
    pub fn export(&self, event_id: &str, policy: &Policy) -> Result<Bundle> {
        let json: String = self
            .connection
            .query_row(
                "SELECT bundle FROM bridge_events WHERE event_id=?1",
                [event_id],
                |r| r.get(0),
            )
            .optional()?
            .context("event not found")?;
        let bundle = serde_json::from_str(&json)?;
        v2::verify(&bundle, policy)?;
        ensure!(
            bundle.request.event.event_id == event_id,
            "export identity mismatch"
        );
        Ok(bundle)
    }
}
