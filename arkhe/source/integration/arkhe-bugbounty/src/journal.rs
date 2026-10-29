//! In-memory reference implementation. Production uses PgOperationJournal.
use crate::{Digest32, Error, WorkIntent, WorkerExecutionRecord};
use async_trait::async_trait;
use std::collections::HashMap;
use tokio::sync::Mutex;
use uuid::Uuid;

// Preserve the established public replay payload without a boxing API migration.
#[allow(clippy::large_enum_variant)]
pub enum Claim {
    Acquired(Uuid),
    Replay(WorkerExecutionRecord),
    Pending,
}
#[async_trait]
pub trait Journal: Send + Sync {
    /// Operational escalation only; never authorizes retry or manufactures evidence.
    async fn require_manual_reconciliation(
        &self,
        _caller: &str,
        _operation: Digest32,
        _reason: &str,
    ) -> Result<(), Error> {
        Ok(())
    }

    async fn claim(&self, intent: &WorkIntent) -> Result<Claim, Error>;
    async fn mark_dispatched(&self, intent: &WorkIntent, owner: Uuid) -> Result<(), Error>;
    async fn complete(
        &self,
        intent: &WorkIntent,
        owner: Uuid,
        record: &WorkerExecutionRecord,
    ) -> Result<(), Error>;
}
struct Entry {
    parameters: Digest32,
    owner: Uuid,
    dispatched: bool,
    response: Option<WorkerExecutionRecord>,
}
#[derive(Default)]
pub struct OperationJournal(Mutex<HashMap<(String, Digest32), Entry>>);
#[async_trait]
impl Journal for OperationJournal {
    async fn claim(&self, i: &WorkIntent) -> Result<Claim, Error> {
        let mut entries = self.0.lock().await;
        let key = (i.requested_by.clone(), i.operation_id());
        if let Some(e) = entries.get(&key) {
            if e.parameters != i.parameters_digest {
                return Err(Error::ParameterMismatch);
            }
            return Ok(match &e.response {
                Some(r) => Claim::Replay(r.clone()),
                None => Claim::Pending,
            });
        }
        let owner = Uuid::new_v4();
        entries.insert(
            key,
            Entry {
                parameters: i.parameters_digest,
                owner,
                dispatched: false,
                response: None,
            },
        );
        Ok(Claim::Acquired(owner))
    }
    async fn mark_dispatched(&self, i: &WorkIntent, owner: Uuid) -> Result<(), Error> {
        let mut entries = self.0.lock().await;
        let e = entries
            .get_mut(&(i.requested_by.clone(), i.operation_id()))
            .ok_or(Error::Uncertain)?;
        if e.owner != owner || e.parameters != i.parameters_digest || e.dispatched {
            return Err(Error::Uncertain);
        }
        e.dispatched = true;
        Ok(())
    }
    async fn complete(
        &self,
        i: &WorkIntent,
        owner: Uuid,
        r: &WorkerExecutionRecord,
    ) -> Result<(), Error> {
        let mut entries = self.0.lock().await;
        let e = entries
            .get_mut(&(i.requested_by.clone(), i.operation_id()))
            .ok_or(Error::Uncertain)?;
        if e.owner != owner
            || e.parameters != i.parameters_digest
            || !e.dispatched
            || r.execution_id != i.operation_id().to_hex()
        {
            return Err(Error::Uncertain);
        }
        e.response = Some(r.clone());
        Ok(())
    }
}
