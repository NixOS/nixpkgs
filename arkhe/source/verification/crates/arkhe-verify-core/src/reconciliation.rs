//! Offline observation prototype. Membership and reproducible matching do not
//! authenticate RPC data, invoices, settlement finality, or economic delivery.
use crate::mmr::{profile::PROFILE_DIGEST_HEX, verify_proof_at, ProofStep};
use arkhe_core::{
    canonical::encode_value, work::WorkIntent, worker::WorkerExecutionRecord, Digest32,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

pub const PROFILE: &str = "arkhe/arc-reconciliation/v1";
pub const MODULE: &str = "arkhe/arc-observer";
const MAX_INVOICES: usize = 256;

fn bytes<T: Serialize>(value: &T) -> Vec<u8> {
    // All projections in this module are bounded structs, strings and integers.
    encode_value(&serde_json::to_value(value).expect("serializable reconciliation projection"))
}
fn digest<T: Serialize>(domain: &[u8], value: &T) -> Digest32 {
    Digest32::blake3(domain, &bytes(value))
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct Transfer {
    pub chain_id: u64,
    pub block_number: u64,
    pub block_hash: String,
    pub transaction_hash: String,
    /// Index after native/ERC-20 duplicate normalization by the capture adapter.
    pub event_index: u32,
    pub from: String,
    pub to: String,
    /// USDC micro-units, not native 18-decimal RPC units. Gas is separate.
    pub amount_microusd: u64,
    pub observed_at: u64,
    /// Explicit correlation supplied by capture; not inferred from Transfer logs.
    pub reference: String,
    pub source: String,
    pub synthetic: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct Invoice {
    pub id: String,
    pub reference: String,
    pub payer: String,
    pub payee: String,
    pub amount_microusd: u64,
    pub valid_from: u64,
    pub valid_until: u64,
    /// Exact supplied document bytes, not an authenticity assertion.
    pub document: Vec<u8>,
    pub synthetic: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct Rule {
    pub profile: String,
    pub chain_id: u64,
    pub payee: String,
}
impl Rule {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:ARC:RECON:RULE:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct Input {
    pub operation_id: Digest32,
    pub rule: Rule,
    pub transfer: Transfer,
    /// Strict ascending ID order defines the canonical input sequence.
    pub invoices: Vec<Invoice>,
}
impl Input {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:ARC:RECON:INPUT:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum Status {
    Matched,
    Partial,
    Excess,
    Unmatched,
    Ambiguous,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct Decision {
    pub input_digest: Digest32,
    pub status: Status,
    pub invoice_ids: Vec<String>,
}
impl Decision {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:ARC:RECON:DECISION:v1\0", self)
    }
}

fn address(value: &str) -> bool {
    hex_string(value, 40)
}
fn hex_string(value: &str, width: usize) -> bool {
    value.len() == width + 2
        && value.starts_with("0x")
        && value[2..]
            .bytes()
            .all(|b| b.is_ascii_digit() || (b'a'..=b'f').contains(&b))
}

/// Independent finite predicate: exact reference + payer + payee + time window.
/// Multiple candidates remain ambiguous; no fuzzy or amount-only auto-match.
pub fn evaluate(input: &Input) -> Result<Decision, &'static str> {
    let t = &input.transfer;
    if input.rule.profile != PROFILE
        || !matches!(input.rule.chain_id, 5042 | 5042002)
        || t.chain_id != input.rule.chain_id
        || !address(&input.rule.payee)
        || t.to != input.rule.payee
        || !address(&t.from)
        || !hex_string(&t.block_hash, 64)
        || !hex_string(&t.transaction_hash, 64)
        || t.amount_microusd == 0
        || t.source.is_empty()
        || t.source.len() > 512
        || t.reference.len() > 256
        || input.invoices.len() > MAX_INVOICES
    {
        return Err("invalid or unsupported reconciliation input");
    }
    let mut ids = BTreeSet::new();
    let mut previous: Option<&str> = None;
    for i in &input.invoices {
        if i.id.is_empty()
            || i.id.len() > 256
            || previous.is_some_and(|p| p >= i.id.as_str())
            || !ids.insert(&i.id)
            || i.reference.is_empty()
            || i.reference.len() > 256
            || !address(&i.payer)
            || !address(&i.payee)
            || i.amount_microusd == 0
            || i.valid_from > i.valid_until
            || i.document.is_empty()
            || i.document.len() > 65536
        {
            return Err("invalid invoice or noncanonical invoice order");
        }
        previous = Some(&i.id);
    }
    let candidates: Vec<_> = input
        .invoices
        .iter()
        .filter(|i| {
            i.reference == t.reference
                && i.payer == t.from
                && i.payee == t.to
                && (i.valid_from..=i.valid_until).contains(&t.observed_at)
        })
        .collect();
    let status = match candidates.as_slice() {
        [] => Status::Unmatched,
        [i] => match t.amount_microusd.cmp(&i.amount_microusd) {
            std::cmp::Ordering::Equal => Status::Matched,
            std::cmp::Ordering::Less => Status::Partial,
            std::cmp::Ordering::Greater => Status::Excess,
        },
        _ => Status::Ambiguous,
    };
    Ok(Decision {
        input_digest: input.digest(),
        status,
        invoice_ids: candidates.iter().map(|i| i.id.clone()).collect(),
    })
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Record {
    pub intent: WorkIntent,
    pub input: Input,
    pub decision: Decision,
    pub worker: WorkerExecutionRecord,
}
impl Record {
    /// Profile-specific leaf; this is not a production PgWormGraph envelope.
    pub fn leaf_bytes(&self) -> Vec<u8> {
        let mut leaf = b"AKG:ARC:RECON:RECORD:v1\0".to_vec();
        leaf.extend(bytes(self));
        leaf
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bundle {
    pub record: Record,
    pub leaf_index: u32,
    pub steps: Vec<ProofStep>,
}

/// Must be provisioned independently of the untrusted bundle. A root copied
/// from an attacker-controlled bundle is not a trust anchor.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Trust {
    pub mmr_profile_digest: String,
    pub root: [u8; 32],
    pub leaf_count: u32,
    pub expected_intent: Digest32,
    pub accepted_rule: Digest32,
}

pub fn verify(bundle: &Bundle, trust: &Trust) -> Result<Decision, &'static str> {
    let r = &bundle.record;
    if trust.mmr_profile_digest != PROFILE_DIGEST_HEX
        || trust.leaf_count == 0
        || trust.leaf_count > 1_000_000
        || bundle.steps.len() > 64
        || r.intent.digest() != trust.expected_intent
        || r.input.rule.digest() != trust.accepted_rule
        || r.input.operation_id != r.intent.operation_id()
        || r.intent.parameters_digest != r.input.digest()
        || r.worker.module_id != MODULE
        || r.worker.module_version != "1"
        || r.worker.input_digest != r.input.digest()
        || r.worker.output_digest != r.decision.digest()
        || r.worker.evidence_refs != vec![r.input.rule.digest()]
    {
        return Err("untrusted profile or mismatched case bindings");
    }
    let decision = evaluate(&r.input)?;
    if decision != r.decision {
        return Err("reconciliation predicate does not reproduce recorded decision");
    }
    if !verify_proof_at(
        &r.leaf_bytes(),
        trust.leaf_count as usize,
        bundle.leaf_index as usize,
        &bundle.steps,
        &trust.root,
    )
    .map_err(|_| "invalid inclusion proof shape")?
    {
        return Err("record absent from trusted checkpoint");
    }
    Ok(decision)
}
