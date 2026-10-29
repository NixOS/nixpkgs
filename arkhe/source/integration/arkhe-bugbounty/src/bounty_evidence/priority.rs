//! External-log priority. No default log, caller timestamp, or first-call winner.
use super::{dh, PayoutJournal, PayoutResult};
use async_trait::async_trait;
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AnchoredClaim {
    pub log_id: [u8; 32],
    pub commitment: [u8; 32],
    pub report_digest: [u8; 32],
    pub recipient: [u8; 32],
    pub anchored_at: u64,
    pub log_position: u64,
    pub chain_id: u64,
    pub submission_block: u64,
}
#[derive(Debug, Clone)]
pub struct PrioritySnapshot {
    pub vulnerability_id: [u8; 32],
    pub log_id: [u8; 32],
    pub closed_at: u64,
    pub finalized: bool,
    pub eligible_claims: Vec<AnchoredClaim>,
}
/// Trusted adapter must authenticate inclusion, time/height, reveal/report binding,
/// eligibility and completeness for a finalized disclosure/claim cutoff.
/// Implementations cannot derive these guarantees from researcher assertions.
#[async_trait]
pub trait AnchorSource: Send + Sync {
    async fn verified_anchor(&self, report: [u8; 32]) -> Result<AnchoredClaim, String>;
    async fn verified_priority_snapshot(
        &self,
        vulnerability: [u8; 32],
    ) -> Result<PrioritySnapshot, String>;
}
pub struct ClosedPriority {
    vulnerability: [u8; 32],
    winner: AnchoredClaim,
    digest: [u8; 32],
}
fn bytes(c: &AnchoredClaim) -> Vec<u8> {
    let mut b = Vec::new();
    for value in [&c.log_id, &c.commitment, &c.report_digest, &c.recipient] {
        b.extend_from_slice(value)
    }
    for value in [
        c.anchored_at,
        c.log_position,
        c.chain_id,
        c.submission_block,
    ] {
        b.extend_from_slice(&value.to_be_bytes())
    }
    b
}
impl ClosedPriority {
    pub async fn resolve<S: AnchorSource>(
        source: &S,
        vulnerability: [u8; 32],
    ) -> Result<Self, String> {
        let mut s = source.verified_priority_snapshot(vulnerability).await?;
        if !s.finalized
            || s.vulnerability_id != vulnerability
            || vulnerability == [0; 32]
            || s.log_id == [0; 32]
            || s.eligible_claims.is_empty()
            || s.eligible_claims.iter().any(|c| {
                c.log_id != s.log_id
                    || c.commitment == [0; 32]
                    || c.report_digest == [0; 32]
                    || c.recipient == [0; 32]
                    || c.chain_id == 0
                    || c.anchored_at > s.closed_at
            })
        {
            return Err("priority snapshot is not authenticated/finalized/eligible".into());
        }
        // The source must supply consistent records for a unique position/commitment.
        for (i, c) in s.eligible_claims.iter().enumerate() {
            if s.eligible_claims[..i].iter().any(|other| {
                other.log_position == c.log_position || other.commitment == c.commitment
            }) {
                return Err("ambiguous/duplicate log claim".into());
            }
        }
        // Equal timestamps use log position, then commitment: never RPC arrival order.
        s.eligible_claims
            .sort_by_key(|c| (c.anchored_at, c.log_position, c.commitment));
        let mut payload = Vec::new();
        payload.extend_from_slice(&vulnerability);
        payload.extend_from_slice(&s.log_id);
        payload.extend_from_slice(&s.closed_at.to_be_bytes());
        for c in &s.eligible_claims {
            payload.extend_from_slice(&bytes(c))
        }
        Ok(Self {
            vulnerability,
            winner: s.eligible_claims[0].clone(),
            digest: dh("ARKHE/PAYOUT-PRIORITY/v1", &[&payload]),
        })
    }
    pub fn digest(&self) -> [u8; 32] {
        self.digest
    }
    pub fn vulnerability_id(&self) -> [u8; 32] {
        self.vulnerability
    }
    pub fn winner(&self) -> &AnchoredClaim {
        &self.winner
    }
}
impl PayoutJournal {
    /// Local simulation only; the closed snapshot comes from a trusted log adapter.
    pub fn pay(
        &mut self,
        op: [u8; 32],
        vulnerability: [u8; 32],
        recipient: [u8; 32],
        amount: u128,
        anchor: &AnchoredClaim,
        priority: &ClosedPriority,
    ) -> PayoutResult {
        if priority.vulnerability != vulnerability {
            return PayoutResult::PriorityNotEstablished;
        }
        if let Some(previous) = self.priority_winners.get(&vulnerability) {
            let order = |c: &AnchoredClaim| (c.anchored_at, c.log_position, c.commitment);
            if priority.winner.log_id != previous.log_id {
                self.reconciliation.insert(vulnerability);
                return PayoutResult::ManualReconciliationRequired;
            }
            if order(&priority.winner) < order(previous) {
                self.reconciliation.insert(vulnerability);
                return PayoutResult::EarlierClaimAfterSettlement;
            }
        }
        if self.reconciliation.contains(&vulnerability) {
            return PayoutResult::ManualReconciliationRequired;
        }
        if anchor != priority.winner() || recipient != anchor.recipient {
            return PayoutResult::NotPriorityWinner;
        }
        let result = self.apply_simulated(op, vulnerability, recipient, amount, priority.digest);
        if result == PayoutResult::Applied {
            self.priority_winners
                .insert(vulnerability, priority.winner.clone());
        }
        result
    }
}

impl PayoutJournal {
    pub fn requires_manual_reconciliation(&self, vulnerability: &[u8; 32]) -> bool {
        self.reconciliation.contains(vulnerability)
    }
}
