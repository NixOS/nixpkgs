//! bounty_evidence v0.1 — local candidate, not production authority.
//! Four components; only deterministic checks/state transitions, no external effects.
//!
//!  A. PocPolicy        : condição de sucesso e ambiente de referência definidos
//!                        pela POLÍTICA (não pelo pesquisador).
//!  B. BlindCommitment  : compromisso cego de pré-existência (só o hash é ancorado).
//!  C. VerifierRegistry : verifier_id <-> chave atestada, com validade/revogação,
//!                        e independência por OPERADOR distinto.
//!  D. PayoutJournal    : in-memory payout simulation and exact-ID deduplication.
//!
//! LIMITES (não resolvidos aqui): escopo/severidade semânticos, atestação de
//! hardware real, canonicalização de `vulnerability_id`, regulação do pagamento.
//! Tudo é puro: tempos e blocos vêm de fora (log de transparência / chain),
//! nunca do relógio local.

use std::collections::BTreeMap;

/// Fixed hash profile for this candidate; does not replace Arkhe BLAKE3 identities.
pub const HASH_PROFILE: &str = "ARKHE-BOUNTY-SHA256-LP-v1";

// Use the existing workspace SHA-256 implementation, not handwritten crypto.
pub fn sha256(data: &[u8]) -> [u8; 32] {
    use sha2::{Digest, Sha256};
    Sha256::digest(data).into()
}

/// Hash com separação de domínio e prefixo de comprimento por parte
/// (evita ambiguidade de concatenação).
pub fn dh(domain: &str, parts: &[&[u8]]) -> [u8; 32] {
    let mut buf = Vec::new();
    buf.extend_from_slice(&(domain.len() as u64).to_be_bytes());
    buf.extend_from_slice(domain.as_bytes());
    for p in parts {
        buf.extend_from_slice(&(p.len() as u64).to_be_bytes());
        buf.extend_from_slice(p);
    }
    sha256(&buf)
}

// ------------------------------------------------- A. PoC policy / oracle
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PocPolicy {
    pub chain_id: u64,
    pub fork_block: u64,
    /// Janela máxima entre bloco do fork e bloco de submissão.
    pub max_block_drift: u64,
    pub in_scope_targets: Vec<[u8; 32]>,
    pub asset_id: [u8; 32],
    pub min_attacker_gain: u128,
}

/// Números MEDIDOS pelo harness (sem LLM). Não há campo "success: bool"
/// fornecido pelo pesquisador: o veredicto é calculado pela política.
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PocMeasurement {
    pub chain_id: u64,
    pub fork_block: u64,
    pub submission_block: u64,
    pub target: [u8; 32],
    pub asset_id: [u8; 32],
    pub attacker_gain: u128,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PocVerdict {
    Pass,
    InvalidPolicy,
    ChainMismatch,
    ForkBlockMismatch,
    ForkOutsideWindow,
    TargetOutOfScope,
    WrongAsset,
    GainBelowThreshold,
}

pub fn evaluate_poc(p: &PocPolicy, m: &PocMeasurement) -> PocVerdict {
    if p.chain_id == 0
        || p.in_scope_targets.is_empty()
        || p.asset_id == [0; 32]
        || p.min_attacker_gain == 0
        || p.in_scope_targets.contains(&[0; 32])
    {
        return PocVerdict::InvalidPolicy;
    }
    if m.chain_id != p.chain_id {
        return PocVerdict::ChainMismatch;
    }
    if m.fork_block != p.fork_block {
        return PocVerdict::ForkBlockMismatch;
    }
    if m.submission_block < m.fork_block || m.submission_block - m.fork_block > p.max_block_drift {
        return PocVerdict::ForkOutsideWindow;
    }
    if !p.in_scope_targets.contains(&m.target) {
        return PocVerdict::TargetOutOfScope;
    }
    if m.asset_id != p.asset_id {
        return PocVerdict::WrongAsset;
    }
    if m.attacker_gain < p.min_attacker_gain {
        return PocVerdict::GainBelowThreshold;
    }
    PocVerdict::Pass
}

// ----------------------------------------------- B. Blind commitment
pub const COMMIT_DOMAIN: &str = "ARKHE/BLIND-COMMIT/v1";

/// C = H(domain, nonce[32], report). Só C é ancorado. O nonce é fornecido
/// pelo chamador (esta função não gera aleatoriedade).
pub fn commit(nonce: &[u8; 32], report: &[u8]) -> [u8; 32] {
    dh(COMMIT_DOMAIN, &[nonce, report])
}

pub fn verify_reveal(commitment: &[u8; 32], nonce: &[u8; 32], report: &[u8]) -> bool {
    &commit(nonce, report) == commitment
}

/// Pré-existência: o ancoramento (tempo vindo do log de transparência)
/// precisa ser ESTRITAMENTE anterior ao patch. Prova existência numa data,
/// não veracidade do conteúdo.
pub fn pre_existence_holds(anchored_at: Option<u64>, patched_at: u64) -> bool {
    matches!(anchored_at, Some(t) if t < patched_at)
}

// --------------------------------------------- C. Verifier registry
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum AttestationLevel {
    None = 0,
    Workload = 1,
    Hardware = 2,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VerifierEntry {
    pub verifier_id: [u8; 32],
    pub operator_id: [u8; 32],
    pub key_id: [u8; 32],
    pub level: AttestationLevel,
    pub not_before: u64,
    pub not_after: u64,
    pub revoked: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RegistryError {
    UnknownVerifier,
    KeyMismatch,
    NotYetValid,
    Expired,
    Revoked,
    AttestationTooWeak,
    InvalidEntry,
    DuplicateVerifier,
    DuplicateKey,
}

#[derive(Default)]
pub struct VerifierRegistry {
    entries: BTreeMap<[u8; 32], VerifierEntry>,
}

impl VerifierRegistry {
    /// Metadata only: caller must authenticate the registry and attestation first.
    /// Re-enrollment cannot silently replace a revoked key/operator binding.
    pub fn insert(&mut self, e: VerifierEntry) -> Result<(), RegistryError> {
        if e.verifier_id == [0; 32]
            || e.operator_id == [0; 32]
            || e.key_id == [0; 32]
            || e.not_before >= e.not_after
        {
            return Err(RegistryError::InvalidEntry);
        }
        if self.entries.contains_key(&e.verifier_id) {
            return Err(RegistryError::DuplicateVerifier);
        }
        if self.entries.values().any(|other| other.key_id == e.key_id) {
            return Err(RegistryError::DuplicateKey);
        }
        self.entries.insert(e.verifier_id, e);
        Ok(())
    }
    pub fn revoke(&mut self, verifier_id: &[u8; 32]) -> Result<(), RegistryError> {
        self.entries
            .get_mut(verifier_id)
            .ok_or(RegistryError::UnknownVerifier)?
            .revoked = true;
        Ok(())
    }

    /// `at` vem de fonte externa confiável (não do relógio local).
    pub fn authenticate(
        &self,
        verifier_id: &[u8; 32],
        signing_key_id: &[u8; 32],
        at: u64,
        min_level: AttestationLevel,
    ) -> Result<&VerifierEntry, RegistryError> {
        let e = self
            .entries
            .get(verifier_id)
            .ok_or(RegistryError::UnknownVerifier)?;
        if &e.key_id != signing_key_id {
            return Err(RegistryError::KeyMismatch);
        }
        if e.revoked {
            return Err(RegistryError::Revoked);
        }
        if at < e.not_before {
            return Err(RegistryError::NotYetValid);
        }
        if at >= e.not_after {
            return Err(RegistryError::Expired);
        }
        if e.level < min_level {
            return Err(RegistryError::AttestationTooWeak);
        }
        Ok(e)
    }

    /// Distinct operator IDs in the configured metadata (not proof of custody).
    /// Counts matching entries among verifier/key claims; signatures are not checked here.
    /// Nº de OPERADORES distintos entre verificadores
    /// autenticados. Dois verifier_id do mesmo operador contam uma vez.
    pub fn independent_operators(
        &self,
        signed: &[([u8; 32], [u8; 32])], // (verifier_id, signing_key_id)
        at: u64,
        min_level: AttestationLevel,
    ) -> usize {
        let mut ops: Vec<[u8; 32]> = signed
            .iter()
            .filter_map(|(v, k)| self.authenticate(v, k, at, min_level).ok())
            .map(|e| e.operator_id)
            .collect();
        ops.sort();
        ops.dedup();
        ops.len()
    }
}

// ------------------------------------------------- D. Payout journal
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PayoutResult {
    /// Simulated bookkeeping only; no payment was dispatched.
    Applied,
    Replayed {
        amount: u128,
    },
    ParameterMismatch,
    DuplicateVulnerability,
    InvalidParameters,
    PriorityNotEstablished,
    NotPriorityWinner,
    EarlierClaimAfterSettlement,
    ManualReconciliationRequired,
}

pub fn operation_id(op_type: &str, target: &[u8], request_identity: &[u8]) -> [u8; 32] {
    dh(
        "ARKHE/OPERATION/v1",
        &[op_type.as_bytes(), target, request_identity],
    )
}

pub fn vulnerability_id(
    target: &[u8],
    function: &[u8],
    bug_class: &[u8],
    trigger: &[u8],
) -> [u8; 32] {
    // Só tão bom quanto a canonicalização dos campos de entrada.
    dh("ARKHE/VULN/v1", &[target, function, bug_class, trigger])
}

/// Process-local simulation. Not durable and no remote exactly-once guarantee.
#[derive(Default)]
pub struct PayoutJournal {
    ops: BTreeMap<[u8; 32], ([u8; 32], u128)>, // op_id -> (params_digest, amount)
    paid_vulns: BTreeMap<[u8; 32], [u8; 32]>,  // vuln_id -> op_id
    priority_winners: BTreeMap<[u8; 32], priority::AnchoredClaim>,
    reconciliation: std::collections::BTreeSet<[u8; 32]>,
}

impl PayoutJournal {
    fn apply_simulated(
        &mut self,
        op_id: [u8; 32],
        vuln_id: [u8; 32],
        recipient: [u8; 32],
        amount: u128,
        priority_binding: [u8; 32],
    ) -> PayoutResult {
        if op_id == [0; 32] || vuln_id == [0; 32] || recipient == [0; 32] || amount == 0 {
            return PayoutResult::InvalidParameters;
        }
        let params = dh(
            "ARKHE/PAYOUT-PARAMS/v3",
            &[
                &vuln_id,
                &recipient,
                &amount.to_be_bytes(),
                &priority_binding,
            ],
        );
        if let Some((d, a)) = self.ops.get(&op_id) {
            return if *d == params {
                PayoutResult::Replayed { amount: *a }
            } else {
                PayoutResult::ParameterMismatch // nenhuma segunda escrita
            };
        }
        if self.paid_vulns.contains_key(&vuln_id) {
            return PayoutResult::DuplicateVulnerability;
        }
        self.ops.insert(op_id, (params, amount));
        self.paid_vulns.insert(vuln_id, op_id);
        PayoutResult::Applied
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn hex(b: &[u8]) -> String {
        b.iter().map(|x| format!("{:02x}", x)).collect()
    }

    // ---- SHA-256 contra vetores FIPS 180-4
    #[test]
    fn sha256_known_vectors() {
        assert_eq!(
            hex(&sha256(b"")),
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        );
        assert_eq!(
            hex(&sha256(b"abc")),
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        );
        assert_eq!(
            hex(&sha256(
                b"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
            )),
            "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
        );
    }

    // ---- A
    fn pol() -> PocPolicy {
        PocPolicy {
            chain_id: 1,
            fork_block: 1000,
            max_block_drift: 50,
            in_scope_targets: vec![[1; 32]],
            asset_id: [9; 32],
            min_attacker_gain: 100,
        }
    }
    fn meas() -> PocMeasurement {
        PocMeasurement {
            chain_id: 1,
            fork_block: 1000,
            submission_block: 1010,
            target: [1; 32],
            asset_id: [9; 32],
            attacker_gain: 100,
        }
    }
    #[test]
    fn poc_pass_and_each_failure() {
        assert_eq!(evaluate_poc(&pol(), &meas()), PocVerdict::Pass);
        let mut m = meas();
        m.chain_id = 2;
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::ChainMismatch);
        let mut m = meas();
        m.fork_block = 999;
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::ForkBlockMismatch);
        let mut m = meas();
        m.submission_block = 1051;
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::ForkOutsideWindow);
        let mut m = meas();
        m.submission_block = 999;
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::ForkOutsideWindow);
        let mut m = meas();
        m.target = [2; 32];
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::TargetOutOfScope);
        let mut m = meas();
        m.asset_id = [8; 32];
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::WrongAsset);
        let mut m = meas();
        m.attacker_gain = 99;
        assert_eq!(evaluate_poc(&pol(), &m), PocVerdict::GainBelowThreshold);
    }

    // ---- B
    #[test]
    fn commitment_binds_report_and_nonce() {
        let n = [3u8; 32];
        let c = commit(&n, b"report-v1");
        assert!(verify_reveal(&c, &n, b"report-v1"));
        assert!(!verify_reveal(&c, &n, b"report-v2"));
        assert!(!verify_reveal(&c, &[4u8; 32], b"report-v1"));
    }
    #[test]
    fn commitment_has_no_concat_ambiguity() {
        // mesmo conjunto de bytes, partição diferente => hash diferente
        assert_ne!(dh("d", &[b"ab", b"c"]), dh("d", &[b"a", b"bc"]));
        // domínios diferentes => hash diferente
        assert_ne!(dh("d1", &[b"x"]), dh("d2", &[b"x"]));
    }
    #[test]
    fn pre_existence_requires_strictly_earlier_anchor() {
        assert!(pre_existence_holds(Some(99), 100));
        assert!(!pre_existence_holds(Some(100), 100));
        assert!(!pre_existence_holds(Some(101), 100));
        assert!(!pre_existence_holds(None, 100));
    }

    // ---- C
    fn entry(v: u8, op: u8, key: u8, lvl: AttestationLevel) -> VerifierEntry {
        VerifierEntry {
            verifier_id: [v; 32],
            operator_id: [op; 32],
            key_id: [key; 32],
            level: lvl,
            not_before: 10,
            not_after: 100,
            revoked: false,
        }
    }
    #[test]
    fn registry_rejects_every_bad_case() {
        let mut r = VerifierRegistry::default();
        r.insert(entry(1, 1, 1, AttestationLevel::Workload))
            .unwrap();
        let ok = r.authenticate(&[1; 32], &[1; 32], 50, AttestationLevel::Workload);
        assert!(ok.is_ok());
        assert_eq!(
            r.authenticate(&[2; 32], &[1; 32], 50, AttestationLevel::None)
                .err(),
            Some(RegistryError::UnknownVerifier)
        );
        assert_eq!(
            r.authenticate(&[1; 32], &[9; 32], 50, AttestationLevel::None)
                .err(),
            Some(RegistryError::KeyMismatch)
        );
        assert_eq!(
            r.authenticate(&[1; 32], &[1; 32], 5, AttestationLevel::None)
                .err(),
            Some(RegistryError::NotYetValid)
        );
        assert_eq!(
            r.authenticate(&[1; 32], &[1; 32], 101, AttestationLevel::None)
                .err(),
            Some(RegistryError::Expired)
        );
        assert_eq!(
            r.authenticate(&[1; 32], &[1; 32], 50, AttestationLevel::Hardware)
                .err(),
            Some(RegistryError::AttestationTooWeak)
        );
        let mut rv = entry(3, 3, 3, AttestationLevel::Hardware);
        rv.revoked = true;
        r.insert(rv).unwrap();
        assert_eq!(
            r.authenticate(&[3; 32], &[3; 32], 50, AttestationLevel::None)
                .err(),
            Some(RegistryError::Revoked)
        );
    }
    #[test]
    fn same_operator_under_two_ids_counts_once() {
        let mut r = VerifierRegistry::default();
        r.insert(entry(1, 7, 1, AttestationLevel::Workload))
            .unwrap(); // operador 7
        r.insert(entry(2, 7, 2, AttestationLevel::Workload))
            .unwrap(); // operador 7 de novo
        r.insert(entry(3, 8, 3, AttestationLevel::Workload))
            .unwrap(); // operador 8
        let two_same = [([1; 32], [1; 32]), ([2; 32], [2; 32])];
        assert_eq!(
            r.independent_operators(&two_same, 50, AttestationLevel::Workload),
            1
        );
        let distinct = [([1; 32], [1; 32]), ([3; 32], [3; 32])];
        assert_eq!(
            r.independent_operators(&distinct, 50, AttestationLevel::Workload),
            2
        );
        // assinatura com chave errada não conta
        let forged = [([1; 32], [1; 32]), ([3; 32], [9; 32])];
        assert_eq!(
            r.independent_operators(&forged, 50, AttestationLevel::Workload),
            1
        );
    }

    // ---- D
    #[test]
    fn payout_exactly_once_and_param_mismatch() {
        let mut j = PayoutJournal::default();
        let op = operation_id("Payout", b"target", b"req-1");
        let vid = vulnerability_id(b"t", b"f", b"reentrancy", b"trig");
        assert_eq!(j.pay_fixture(op, vid, [5; 32], 1000), PayoutResult::Applied);
        assert_eq!(
            j.pay_fixture(op, vid, [5; 32], 1000),
            PayoutResult::Replayed { amount: 1000 }
        );
        assert_eq!(
            j.pay_fixture(op, vid, [5; 32], 9999),
            PayoutResult::ParameterMismatch
        );
        assert_eq!(
            j.pay_fixture(op, vid, [6; 32], 1000),
            PayoutResult::ParameterMismatch
        );
        // o valor original permanece
        assert_eq!(
            j.pay_fixture(op, vid, [5; 32], 1000),
            PayoutResult::Replayed { amount: 1000 }
        );
    }
    #[test]
    fn second_report_of_same_bug_is_not_paid() {
        let mut j = PayoutJournal::default();
        let vid = vulnerability_id(b"t", b"f", b"reentrancy", b"trig");
        let op1 = operation_id("Payout", b"t", b"alice");
        let op2 = operation_id("Payout", b"t", b"bob");
        assert_eq!(j.pay_fixture(op1, vid, [1; 32], 500), PayoutResult::Applied);
        assert_eq!(
            j.pay_fixture(op2, vid, [2; 32], 500),
            PayoutResult::DuplicateVulnerability
        );
        // bug diferente é pago normalmente
        let vid2 = vulnerability_id(b"t", b"g", b"overflow", b"trig2");
        assert_eq!(
            j.pay_fixture(op2, vid2, [2; 32], 500),
            PayoutResult::Applied
        );
    }
    #[test]
    fn operation_ids_differ_by_type_target_request() {
        let a = operation_id("Payout", b"x", b"r");
        assert_ne!(a, operation_id("Revoke", b"x", b"r"));
        assert_ne!(a, operation_id("Payout", b"y", b"r"));
        assert_ne!(a, operation_id("Payout", b"x", b"s"));
    }
}
#[cfg(test)]
mod regressions {
    use super::*;
    #[test]
    fn same_operation_different_bug_is_parameter_conflict_and_does_not_consume_bug() {
        let mut j = PayoutJournal::default();
        let op = [1; 32];
        let first = [2; 32];
        let second = [3; 32];
        assert_eq!(
            j.pay_fixture(op, first, [4; 32], 100),
            PayoutResult::Applied
        );
        assert_eq!(
            j.pay_fixture(op, second, [4; 32], 100),
            PayoutResult::ParameterMismatch
        );
        assert_eq!(
            j.pay_fixture([5; 32], second, [4; 32], 100),
            PayoutResult::Applied
        );
        assert_eq!(
            j.pay_fixture(op, first, [4; 32], 100),
            PayoutResult::Replayed { amount: 100 }
        );
    }
    #[test]
    fn registry_rejects_replacement_invalid_entries_and_expiry_boundary() {
        let mut r = VerifierRegistry::default();
        let e = VerifierEntry {
            verifier_id: [1; 32],
            operator_id: [2; 32],
            key_id: [3; 32],
            level: AttestationLevel::Workload,
            not_before: 10,
            not_after: 100,
            revoked: false,
        };
        assert_eq!(
            r.insert(VerifierEntry {
                operator_id: [0; 32],
                ..e.clone()
            }),
            Err(RegistryError::InvalidEntry)
        );
        assert_eq!(
            r.insert(VerifierEntry {
                not_after: 10,
                ..e.clone()
            }),
            Err(RegistryError::InvalidEntry)
        );
        r.insert(e.clone()).unwrap();
        assert!(r
            .authenticate(&[1; 32], &[3; 32], 10, AttestationLevel::Workload)
            .is_ok());
        assert_eq!(
            r.authenticate(&[1; 32], &[3; 32], 100, AttestationLevel::Workload)
                .err(),
            Some(RegistryError::Expired)
        );
        r.revoke(&[1; 32]).unwrap();
        assert_eq!(r.insert(e), Err(RegistryError::DuplicateVerifier));
        assert_eq!(
            r.authenticate(&[1; 32], &[3; 32], 50, AttestationLevel::Workload)
                .err(),
            Some(RegistryError::Revoked)
        );
    }
    #[test]
    fn poc_rejects_empty_scope_and_zero_gain_policy_and_handles_block_limits() {
        let p = PocPolicy {
            chain_id: 1,
            fork_block: u64::MAX,
            max_block_drift: 0,
            in_scope_targets: vec![[1; 32]],
            asset_id: [2; 32],
            min_attacker_gain: 1,
        };
        let m = PocMeasurement {
            chain_id: 1,
            fork_block: u64::MAX,
            submission_block: u64::MAX,
            target: [1; 32],
            asset_id: [2; 32],
            attacker_gain: 1,
        };
        assert_eq!(evaluate_poc(&p, &m), PocVerdict::Pass);
        assert_eq!(
            evaluate_poc(
                &PocPolicy {
                    min_attacker_gain: 0,
                    ..p.clone()
                },
                &m
            ),
            PocVerdict::InvalidPolicy
        );
        assert_eq!(
            evaluate_poc(
                &PocPolicy {
                    in_scope_targets: vec![],
                    ..p
                },
                &m
            ),
            PocVerdict::InvalidPolicy
        );
    }
}

#[cfg(test)]
mod payout_bounds {
    use super::*;
    #[test]
    fn invalid_payout_does_not_reserve_operation_or_bug() {
        let mut j = PayoutJournal::default();
        for (op, vuln, recipient, amount) in [
            ([0; 32], [2; 32], [3; 32], 1),
            ([1; 32], [0; 32], [3; 32], 1),
            ([1; 32], [2; 32], [0; 32], 1),
            ([1; 32], [2; 32], [3; 32], 0),
        ] {
            assert_eq!(
                j.pay_fixture(op, vuln, recipient, amount),
                PayoutResult::InvalidParameters
            );
        }
        assert_eq!(
            j.pay_fixture([1; 32], [2; 32], [3; 32], u128::MAX),
            PayoutResult::Applied
        );
    }
}

/// Policy-bound PoC assessment; does not authorize a transition.
pub mod policy;

#[cfg(test)]
impl PayoutJournal {
    // Old bookkeeping tests do not model anchor priority; no public bypass exists.
    fn pay_fixture(
        &mut self,
        op: [u8; 32],
        vuln: [u8; 32],
        recipient: [u8; 32],
        amount: u128,
    ) -> PayoutResult {
        self.apply_simulated(op, vuln, recipient, amount, [0; 32])
    }
}
pub mod priority;

pub mod identity;
pub mod signed_poc;

pub mod v2;

pub mod trust;

pub mod durable;
