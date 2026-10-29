//! Host-side effect boundary. Agent processes must not possess the executor or
//! its credentials. OS isolation and durable storage are deployment obligations.
use crate::{AuthorizationDecision, ContainmentGate};
use arkhe_core::{
    evidence::EvidenceReader, work::WorkIntent, worker::WorkerExecutionRecord, Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver};
use arkhe_verify_core::action_proof::{self, ActionProof, Trust};

pub enum Reservation {
    Acquired,
    Replay(Vec<u8>),
    Uncertain,
}

/// Implementations MUST atomically reserve (caller, operation), comparing the
/// complete binding, persist before dispatch, and never take over uncertain work.
/// An acquired entry remains uncertain after cancellation, panic or storage error.
/// No in-memory implementation is installed as a production default.
pub trait DispatchJournal {
    /// Atomically consumes a caller nonce and reserves dispatch. No fallback to
    /// an old journal that lacks nonce uniqueness is permitted.
    fn reserve_authenticated(
        &mut self,
        _caller: &str,
        _operation: Digest32,
        _binding: Digest32,
        _nonce: Digest32,
    ) -> Result<Reservation, String> {
        Err("journal lacks atomic authenticated nonce consumption".into())
    }
    /// Atomic reservation plus unique closed-mandate consumption across operations.
    /// Older journals fail closed until this capability is explicitly implemented.
    fn reserve_payment(
        &mut self,
        _caller: &str,
        _operation: Digest32,
        _binding: Digest32,
        _closed_mandate: Digest32,
    ) -> Result<Reservation, String> {
        Err("journal lacks atomic closed-mandate consumption".into())
    }
    fn reserve(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
    ) -> Result<Reservation, String>;
    fn complete(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        receipt: &[u8],
    ) -> Result<(), String>;
}

/// A trusted host implements this against one configured capability. The agent
/// cannot select executable paths, URLs or credentials through a broker parameter.
pub trait CapabilityExecutor {
    fn execute(&mut self, intent: &WorkIntent) -> Result<Vec<u8>, String>;
    /// Migrated capability consumes exactly the authenticated action. Old
    /// executors must explicitly adapt their parameter schema before dispatch.
    fn execute_authenticated(
        &mut self,
        _intent: &WorkIntent,
        _action: &arkhe_verify_core::policy::Action,
    ) -> Result<Vec<u8>, String> {
        Err("executor lacks authenticated parameter adapter".into())
    }
}

#[cfg(feature = "sqlite-broker")]
impl<R: PolicyResolver, X: CapabilityExecutor>
    CapabilityBroker<R, crate::broker_sqlite::SqliteDispatchJournal, X>
{
    /// Local SQLite effects only. External effects must use reserve-before-send
    /// and preserve uncertainty, or an actual provider idempotency contract.
    #[allow(clippy::too_many_arguments)]
    pub async fn execute_authenticated_local<E: EvidenceReader, F>(
        &mut self,
        intent: &WorkIntent,
        worker: &WorkerExecutionRecord,
        policy: &PolicyBinding,
        evidence: &E,
        proof: &ActionProof,
        trust: &Trust,
        effect: F,
    ) -> Result<crate::broker_sqlite::TransactionalResult, String>
    where
        F: FnOnce(
            &rusqlite::Transaction<'_>,
            &arkhe_verify_core::policy::Action,
        ) -> Result<Vec<u8>, String>,
    {
        if self
            .gate
            .resolver
            .required_formal_predicate(intent, policy)
            .is_some()
            || policy.policy_digest != trust.policy_digest
        {
            return Err("local transaction profile/mandate mismatch".into());
        }
        let request = self
            .gate
            .authenticated_request(intent, worker, policy, evidence)
            .await?
            .ok_or("local transaction requires authenticated policy")?;
        let mandate = action_proof::verify(proof, intent, trust).map_err(str::to_owned)?;
        if let AuthorizationDecision::Reject { reason } = self
            .gate
            .authorize_admitted(intent, worker, policy, evidence)
            .await
        {
            return Err(reason);
        }
        let mut bytes = intent.parameters_digest.0.to_vec();
        bytes.extend_from_slice(&mandate.0);
        bytes.extend_from_slice(&policy.policy_digest.0);
        bytes.extend_from_slice(&request.signed_intent.intent.policy_digest);
        let binding = Digest32::blake3(b"AKG:BROKER:DISPATCH:v1\0", &bytes);
        let mut nonce = intent.requested_by.as_bytes().to_vec();
        nonce.extend_from_slice(&intent.request_identity.0 .0);
        let nonce = Digest32::blake3(b"AKG:BROKER:AUTH-NONCE:v1\0", &nonce);
        self.journal.transact_authenticated(
            &intent.requested_by,
            intent.operation_id(),
            binding,
            nonce,
            |tx| effect(tx, &request.action),
        )
    }
}

pub struct CapabilityBroker<R: PolicyResolver, J: DispatchJournal, X: CapabilityExecutor> {
    gate: ContainmentGate<R>,
    journal: J,
    executor: X,
}
impl<R: PolicyResolver, J: DispatchJournal, X: CapabilityExecutor> CapabilityBroker<R, J, X> {
    pub fn new(gate: ContainmentGate<R>, journal: J, executor: X) -> Self {
        Self {
            gate,
            journal,
            executor,
        }
    }
    pub fn set_emergency_stop(&mut self, enabled: bool) {
        self.gate.set_emergency_stop(enabled);
    }
    /// AP2-role-validated path. The required Payment predicate is checked by the
    /// gate; no local mandate is substituted for AP2 protocol validation.
    pub async fn execute_payment<E: EvidenceReader>(
        &mut self,
        intent: &WorkIntent,
        worker: &WorkerExecutionRecord,
        policy: &PolicyBinding,
        evidence: &E,
    ) -> Result<Vec<u8>, String> {
        if self
            .gate
            .resolver
            .authenticated_context(intent, policy)
            .is_some()
        {
            return Err("AP2 needs combined mandate/nonce journal support; authenticated profile cannot bypass it".into());
        }
        if !matches!(
            self.gate.resolver.required_formal_predicate(intent, policy),
            Some(arkhe_core::formal_proof::FormalPredicate::PaymentMandate(_))
        ) {
            return Err("payment capability requires AP2 formal predicate".into());
        }
        // The same credential may have multiple SD-JWT presentations. Never use
        // raw presentation bytes as its single-use identity. A later gate read
        // must authenticate the SAME role digest bound by this worker record.
        let consumption = match evidence.formal_proof(worker.digest()).await? {
            Some(arkhe_core::formal_proof::ProofCarryingOutput::PaymentMandate(proof))
                if proof.role.digest() == worker.input_digest =>
            {
                proof.role.closed_mandate_id
            }
            _ => return Err("payment consumption identity unavailable or unbound".into()),
        };
        match self
            .gate
            .authorize_admitted(intent, worker, policy, evidence)
            .await
        {
            AuthorizationDecision::Allow { .. } => {}
            AuthorizationDecision::Reject { reason } => return Err(reason),
        }
        let mut bytes = intent.parameters_digest.0.to_vec();
        bytes.extend_from_slice(&intent.target.0);
        bytes.extend_from_slice(&policy.policy_digest.0);
        let binding = Digest32::blake3(b"AKG:BROKER:AP2:DISPATCH:v1\0", &bytes);
        let id = intent.operation_id();
        match self
            .journal
            .reserve_payment(&intent.requested_by, id, binding, consumption)?
        {
            Reservation::Replay(receipt) => return Ok(receipt),
            Reservation::Uncertain => {
                return Err("manual reconciliation required; payment not repeated".into())
            }
            Reservation::Acquired => {}
        }
        let receipt = self.executor.execute(intent)?;
        self.journal
            .complete(&intent.requested_by, id, binding, &receipt)?;
        Ok(receipt)
    }
    #[allow(clippy::too_many_arguments)]
    pub async fn execute<E: EvidenceReader>(
        &mut self,
        intent: &WorkIntent,
        worker: &WorkerExecutionRecord,
        policy: &PolicyBinding,
        evidence: &E,
        proof: &ActionProof,
        trust: &Trust,
    ) -> Result<Vec<u8>, String> {
        if matches!(
            self.gate.resolver.required_formal_predicate(intent, policy),
            Some(arkhe_core::formal_proof::FormalPredicate::PaymentMandate(_))
        ) {
            return Err("payment predicates require atomic closed-mandate consumption path".into());
        }
        if policy.policy_digest != trust.policy_digest {
            return Err("broker policy does not match mandate trust".into());
        }
        let mandate = action_proof::verify(proof, intent, trust).map_err(str::to_owned)?;
        let authenticated = self
            .gate
            .authenticated_request(intent, worker, policy, evidence)
            .await?;
        let authorization = match self
            .gate
            .authorize_admitted(intent, worker, policy, evidence)
            .await
        {
            AuthorizationDecision::Allow { authorization_ref } => authorization_ref,
            AuthorizationDecision::Reject { reason } => return Err(reason),
        };
        // Context/worker evidence may be refreshed on a retry. The immutable
        // dispatch binding instead fixes principal, parameters, mandate and policy.
        let mut bytes = intent.parameters_digest.0.to_vec();
        bytes.extend_from_slice(&mandate.0);
        bytes.extend_from_slice(&policy.policy_digest.0);
        if let Some(request) = &authenticated {
            bytes.extend_from_slice(&request.signed_intent.intent.policy_digest);
        }
        let binding = Digest32::blake3(b"AKG:BROKER:DISPATCH:v1\0", &bytes);
        let _checked_authorization = authorization;
        let id = intent.operation_id();
        let reservation = if authenticated.is_some() {
            // Consumption is global across targets/types for the same caller's
            // request nonce; changing the operation ID cannot reuse that nonce.
            let mut nonce = intent.requested_by.as_bytes().to_vec();
            nonce.extend_from_slice(&intent.request_identity.0 .0);
            let nonce = Digest32::blake3(b"AKG:BROKER:AUTH-NONCE:v1\0", &nonce);
            self.journal
                .reserve_authenticated(&intent.requested_by, id, binding, nonce)?
        } else {
            self.journal.reserve(&intent.requested_by, id, binding)?
        };
        match reservation {
            Reservation::Replay(receipt) => return Ok(receipt),
            Reservation::Uncertain => {
                return Err("manual reconciliation required; dispatch not repeated".into())
            }
            Reservation::Acquired => {}
        }
        // Failure and cancellation intentionally leave the reservation uncertain.
        let receipt = match &authenticated {
            Some(request) => self
                .executor
                .execute_authenticated(intent, &request.action)?,
            None => self.executor.execute(intent)?,
        };
        self.journal
            .complete(&intent.requested_by, id, binding, &receipt)?;
        Ok(receipt)
    }
}
