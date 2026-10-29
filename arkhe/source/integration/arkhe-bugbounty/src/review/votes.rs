//! ReviewRouter v0.1 — função pura e determinística.
//!
//! ReviewDecision = F(Assessment, VerifierVotes, Policy, SourceBudget)
//!
//! Candidate only: not connected to admission or execution. Votes are caller claims.
//! Tests cover all integer confidence values for the stated finite vote/policy domain.
//! Properties:
//!   P1  Sem I/O, sem relógio, sem aleatoriedade, sem floats.
//!   P2  AutoAccept exige política explícita (default = ReviewRequired).
//!   P3  High/Critical nunca são AutoAccept apenas com votos de Model.
//!   P4  Conflito entre verificadores => ReviewRequired.
//!   P5  Monotonia: aumentar a severidade nunca torna a decisão menos estrita.
//!   P6  O roteador NÃO autoriza transições (INV-ARKHE-27): só recomenda.
//!       Quem autoriza é o ContainmentGate.

// Reuse the integration severity type; do not change its existing wire format.
pub use crate::Severity;
fn severity_rank(s: Severity) -> usize {
    match s {
        Severity::Info => 0,
        Severity::Low => 1,
        Severity::Medium => 2,
        Severity::High => 3,
        Severity::Critical => 4,
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum VerifierKind {
    /// Analisador estático / checagem determinística de domínio.
    Deterministic,
    /// Reprodução executável (PoC, replay) num harness sem LLM.
    Replay,
    /// Qualquer LLM (ex.: Ollama). Nunca suficiente sozinho para High/Critical.
    Model,
}

impl VerifierKind {
    fn is_independent_of_model(self) -> bool {
        !matches!(self, VerifierKind::Model)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Outcome {
    Confirmed,
    Refuted,
    Inconclusive,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Vote {
    pub kind: VerifierKind,
    pub outcome: Outcome,
    /// Identity authenticated upstream. A caller-chosen hash is not provenance.
    pub verifier_id: [u8; 32],
}

/// Saída do analisador já validada contra schema a montante.
/// `None` = saída malformada (falha silenciosa de structured output).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Assessment {
    pub severity: Severity,
    /// Confiança declarada em permilagem (0..=1000). Inteiro: sem floats.
    pub confidence_permille: u16,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Policy {
    /// Digest da ResolvedPolicyArtifact (opaco aqui; ecoado na decisão).
    pub policy_digest: [u8; 32],
    pub auto_accept_enabled: bool,
    pub auto_reject_enabled: bool,
    /// Threshold order: Info, Low, Medium, High, Critical (not enum discriminants).
    pub min_confidence_permille: [u16; 5],
    /// Nº mínimo de confirmações não-Model para High/Critical.
    pub required_independent_confirmations: u8,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Decision {
    AutoAccept,
    ReviewRequired,
    AutoReject,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Reason {
    AssessmentInvalid,
    PolicyInvalid,
    SourceBudgetExhausted,
    VerifierConflict,
    VerifierIdentityInvalid,
    VerifierRegistryRejected,
    AutoAcceptDisabled,
    InsufficientIndependentEvidence,
    LowConfidence,
    ConfirmedWithinPolicy,
    RefutedByIndependentVerifier,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReviewDecision {
    pub decision: Decision,
    pub reason: Reason,
    pub policy_digest: [u8; 32],
}

pub fn route(
    assessment: Option<Assessment>,
    votes: &[Vote],
    policy: &Policy,
    source_budget_available: bool,
) -> ReviewDecision {
    let out = |decision, reason| ReviewDecision {
        decision,
        reason,
        policy_digest: policy.policy_digest,
    };

    // Monotonic thresholds are required for P5; arbitrary policies do not imply it.
    if policy.min_confidence_permille.iter().any(|c| *c > 1000)
        || policy
            .min_confidence_permille
            .windows(2)
            .any(|w| w[0] > w[1])
        || policy.policy_digest == [0; 32]
    {
        return out(Decision::ReviewRequired, Reason::PolicyInvalid);
    }

    // R1: saída malformada => nunca auto-aceitar (fail-closed). Sem retry cego.
    let a = match assessment {
        Some(a) if a.confidence_permille <= 1000 => a,
        _ => return out(Decision::ReviewRequired, Reason::AssessmentInvalid),
    };

    // R2: orçamento da fonte esgotado => humano decide (anti-inundação).
    if !source_budget_available {
        return out(Decision::ReviewRequired, Reason::SourceBudgetExhausted);
    }

    // One identity cannot claim multiple verifier categories. Zero is not an identity.
    // Conflicting outcomes still reach the ordinary conflict rule below.
    if votes.iter().any(|v| {
        v.verifier_id == [0; 32]
            || votes
                .iter()
                .any(|other| other.verifier_id == v.verifier_id && other.kind != v.kind)
    }) {
        return out(Decision::ReviewRequired, Reason::VerifierIdentityInvalid);
    }

    let confirmed = votes.iter().any(|v| v.outcome == Outcome::Confirmed);
    let refuted = votes.iter().any(|v| v.outcome == Outcome::Refuted);

    // R3: conflito.
    if confirmed && refuted {
        return out(Decision::ReviewRequired, Reason::VerifierConflict);
    }

    // R4: refutação por verificador independente de modelo.
    let independent_refuted = votes
        .iter()
        .any(|v| v.outcome == Outcome::Refuted && v.kind.is_independent_of_model());
    if independent_refuted && policy.auto_reject_enabled {
        return out(Decision::AutoReject, Reason::RefutedByIndependentVerifier);
    }

    // R5: AutoAccept só por política explícita.
    if !policy.auto_accept_enabled {
        return out(Decision::ReviewRequired, Reason::AutoAcceptDisabled);
    }

    // R6: evidência independente de modelo para High/Critical.
    if severity_rank(a.severity) >= severity_rank(Severity::High) {
        // Ordered set: no randomized hash state; duplicate identities count once.
        // Distinct IDs do not themselves establish independent custody or execution.
        let n = votes
            .iter()
            .filter(|v| v.outcome == Outcome::Confirmed && v.kind.is_independent_of_model())
            .map(|v| v.verifier_id)
            .collect::<std::collections::BTreeSet<_>>()
            .len();
        if n < policy.required_independent_confirmations.max(1) as usize {
            return out(
                Decision::ReviewRequired,
                Reason::InsufficientIndependentEvidence,
            );
        }
    }

    // R7: zona cinzenta por confiança.
    if a.confidence_permille < policy.min_confidence_permille[severity_rank(a.severity)] {
        return out(Decision::ReviewRequired, Reason::LowConfidence);
    }

    // R8: sem nenhuma confirmação, não há base para aceitar.
    if !confirmed {
        return out(
            Decision::ReviewRequired,
            Reason::InsufficientIndependentEvidence,
        );
    }

    out(Decision::AutoAccept, Reason::ConfirmedWithinPolicy)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn policy() -> Policy {
        Policy {
            policy_digest: [7; 32],
            auto_accept_enabled: true,
            auto_reject_enabled: true,
            min_confidence_permille: [500, 600, 700, 900, 950],
            required_independent_confirmations: 1,
        }
    }
    fn a(s: Severity, c: u16) -> Option<Assessment> {
        Some(Assessment {
            severity: s,
            confidence_permille: c,
        })
    }
    fn v(kind: VerifierKind, outcome: Outcome) -> Vote {
        Vote {
            kind,
            outcome,
            verifier_id: [match kind {
                VerifierKind::Model => 1,
                VerifierKind::Replay => 2,
                VerifierKind::Deterministic => 3,
            }; 32],
        }
    }

    #[test]
    fn malformed_assessment_never_auto_accepts() {
        let d = route(
            None,
            &[v(VerifierKind::Replay, Outcome::Confirmed)],
            &policy(),
            true,
        );
        assert_eq!(d.decision, Decision::ReviewRequired);
        assert_eq!(d.reason, Reason::AssessmentInvalid);
        let d = route(a(Severity::Low, 1001), &[], &policy(), true);
        assert_eq!(d.reason, Reason::AssessmentInvalid);
    }

    #[test]
    fn default_policy_disabled_is_review() {
        let mut p = policy();
        p.auto_accept_enabled = false;
        let d = route(
            a(Severity::Low, 1000),
            &[v(VerifierKind::Deterministic, Outcome::Confirmed)],
            &p,
            true,
        );
        assert_eq!(d.decision, Decision::ReviewRequired);
        assert_eq!(d.reason, Reason::AutoAcceptDisabled);
    }

    #[test]
    fn critical_high_confidence_model_only_is_review() {
        let d = route(
            a(Severity::Critical, 1000),
            &[v(VerifierKind::Model, Outcome::Confirmed)],
            &policy(),
            true,
        );
        assert_eq!(d.decision, Decision::ReviewRequired);
        assert_eq!(d.reason, Reason::InsufficientIndependentEvidence);
    }

    #[test]
    fn critical_with_replay_and_confidence_accepts() {
        let d = route(
            a(Severity::Critical, 960),
            &[v(VerifierKind::Replay, Outcome::Confirmed)],
            &policy(),
            true,
        );
        assert_eq!(d.decision, Decision::AutoAccept);
    }

    #[test]
    fn conflict_goes_to_review() {
        let votes = [
            v(VerifierKind::Model, Outcome::Confirmed),
            v(VerifierKind::Deterministic, Outcome::Refuted),
        ];
        let d = route(a(Severity::Low, 1000), &votes, &policy(), true);
        assert_eq!(d.reason, Reason::VerifierConflict);
    }

    #[test]
    fn model_refutation_alone_never_auto_rejects() {
        let d = route(
            a(Severity::Low, 900),
            &[v(VerifierKind::Model, Outcome::Refuted)],
            &policy(),
            true,
        );
        assert_ne!(d.decision, Decision::AutoReject);
    }

    #[test]
    fn independent_refutation_auto_rejects_only_if_policy_allows() {
        let votes = [v(VerifierKind::Deterministic, Outcome::Refuted)];
        assert_eq!(
            route(a(Severity::Low, 900), &votes, &policy(), true).decision,
            Decision::AutoReject
        );
        let mut p = policy();
        p.auto_reject_enabled = false;
        assert_eq!(
            route(a(Severity::Low, 900), &votes, &p, true).decision,
            Decision::ReviewRequired
        );
    }

    #[test]
    fn exhausted_source_budget_forces_review() {
        let d = route(
            a(Severity::Low, 1000),
            &[v(VerifierKind::Replay, Outcome::Confirmed)],
            &policy(),
            false,
        );
        assert_eq!(d.reason, Reason::SourceBudgetExhausted);
    }

    #[test]
    fn no_confirmation_never_accepts() {
        let d = route(a(Severity::Info, 1000), &[], &policy(), true);
        assert_eq!(d.decision, Decision::ReviewRequired);
    }

    #[test]
    fn policy_digest_is_echoed() {
        let d = route(None, &[], &policy(), true);
        assert_eq!(d.policy_digest, [7; 32]);
    }

    // ---- Exaustivo: P3 e P5 sobre o domínio finito ----
    const SEVS: [Severity; 5] = [
        Severity::Info,
        Severity::Low,
        Severity::Medium,
        Severity::High,
        Severity::Critical,
    ];
    const KINDS: [VerifierKind; 3] = [
        VerifierKind::Deterministic,
        VerifierKind::Replay,
        VerifierKind::Model,
    ];
    const OUTS: [Outcome; 3] = [Outcome::Confirmed, Outcome::Refuted, Outcome::Inconclusive];

    fn strictness(d: Decision) -> u8 {
        match d {
            Decision::AutoAccept => 0,
            Decision::ReviewRequired => 1,
            Decision::AutoReject => 2, // Strict order: acceptance < deferral < rejection.
        }
    }

    #[test]
    fn exhaustive_p3_p5() {
        let mut checked = 0u64;
        for &s in &SEVS {
            for conf in 0..=1000u16 {
                for &k1 in &KINDS {
                    for &o1 in &OUTS {
                        for &k2 in &KINDS {
                            for &o2 in &OUTS {
                                for &acc in &[true, false] {
                                    let votes = [v(k1, o1), v(k2, o2)];
                                    let mut p = policy();
                                    p.auto_accept_enabled = acc;
                                    let d = route(a(s, conf), &votes, &p, true);
                                    // P2
                                    if !acc {
                                        assert_ne!(d.decision, Decision::AutoAccept);
                                    }
                                    // P3
                                    if severity_rank(s) >= severity_rank(Severity::High)
                                        && d.decision == Decision::AutoAccept
                                    {
                                        assert!(votes
                                            .iter()
                                            .any(|x| x.outcome == Outcome::Confirmed
                                                && x.kind != VerifierKind::Model));
                                    }
                                    // P4
                                    let c = votes.iter().any(|x| x.outcome == Outcome::Confirmed);
                                    let r = votes.iter().any(|x| x.outcome == Outcome::Refuted);
                                    if c && r {
                                        assert_eq!(d.reason, Reason::VerifierConflict);
                                    }
                                    // P5: severidade maior nunca é mais frouxa
                                    for &s2 in &SEVS {
                                        if severity_rank(s2) > severity_rank(s) {
                                            let d2 = route(a(s2, conf), &votes, &p, true);
                                            assert!(
                                                strictness(d2.decision) >= strictness(d.decision),
                                                "monotonia violada: {:?}->{:?} conf={}",
                                                s,
                                                s2,
                                                conf
                                            );
                                        }
                                    }
                                    checked += 1;
                                }
                            }
                        }
                    }
                }
            }
        }
        assert_eq!(checked, 810_810);
    }
}
impl Default for Policy {
    fn default() -> Self {
        Self {
            policy_digest: [0; 32],
            auto_accept_enabled: false,
            auto_reject_enabled: false,
            min_confidence_permille: [1000; 5],
            required_independent_confirmations: 2,
        }
    }
}
#[cfg(test)]
mod hardening_tests {
    use super::*;
    fn policy() -> Policy {
        Policy {
            policy_digest: [7; 32],
            auto_accept_enabled: true,
            auto_reject_enabled: true,
            min_confidence_permille: [500, 600, 700, 900, 950],
            required_independent_confirmations: 2,
        }
    }
    #[test]
    fn duplicate_votes_do_not_satisfy_quorum_or_hide_conflict() {
        let a = Some(Assessment {
            severity: Severity::Critical,
            confidence_permille: 1000,
        });
        let confirmed = Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Confirmed,
            verifier_id: [2; 32],
        };
        assert_eq!(
            route(a, &[confirmed, confirmed], &policy(), true).reason,
            Reason::InsufficientIndependentEvidence
        );
        let deterministic = Vote {
            kind: VerifierKind::Deterministic,
            outcome: Outcome::Confirmed,
            verifier_id: [3; 32],
        };
        assert_eq!(
            route(a, &[confirmed, confirmed, deterministic], &policy(), true).decision,
            Decision::AutoAccept
        );
        let conflict = Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Refuted,
            verifier_id: [2; 32],
        };
        assert_eq!(
            route(a, &[confirmed, confirmed, conflict], &policy(), true).reason,
            Reason::VerifierConflict
        );
    }
    #[test]
    fn policy_bounds_monotonicity_default_and_order_invariance() {
        let a = Some(Assessment {
            severity: Severity::Low,
            confidence_permille: 1000,
        });
        let yes = Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Confirmed,
            verifier_id: [2; 32],
        };
        let no = Vote {
            kind: VerifierKind::Model,
            outcome: Outcome::Refuted,
            verifier_id: [1; 32],
        };
        let p = policy();
        assert_eq!(
            route(a, &[yes, no], &p, true),
            route(a, &[no, yes], &p, true)
        );
        let mut p = policy();
        p.min_confidence_permille = [900, 500, 700, 900, 950];
        assert_eq!(route(a, &[yes], &p, true).reason, Reason::PolicyInvalid);
        p.min_confidence_permille = [1001; 5];
        assert_eq!(route(a, &[yes], &p, true).reason, Reason::PolicyInvalid);
        assert_eq!(
            route(a, &[yes], &Policy::default(), true).decision,
            Decision::ReviewRequired
        );
        let mut p = policy();
        p.auto_accept_enabled = false;
        p.auto_reject_enabled = false;
        for votes in [&[yes][..], &[no][..], &[yes, no][..]] {
            assert_eq!(route(a, votes, &p, true).decision, Decision::ReviewRequired);
        }
    }
}

#[cfg(test)]
mod identity_regressions {
    use super::*;
    fn policy() -> Policy {
        Policy {
            policy_digest: [7; 32],
            auto_accept_enabled: true,
            auto_reject_enabled: true,
            min_confidence_permille: [500, 600, 700, 900, 950],
            required_independent_confirmations: 2,
        }
    }
    #[test]
    fn distinct_replay_identities_count_once_each_and_invalid_ids_defer() {
        let a = Some(Assessment {
            severity: Severity::Critical,
            confidence_permille: 1000,
        });
        let first = Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Confirmed,
            verifier_id: [1; 32],
        };
        let second = Vote {
            verifier_id: [2; 32],
            ..first
        };
        let p = policy();
        assert_eq!(
            route(a, &[first, first], &p, true).decision,
            Decision::ReviewRequired
        );
        assert_eq!(
            route(a, &[first, second, first], &p, true).decision,
            Decision::AutoAccept
        );
        assert_eq!(
            route(a, &[second, first, second], &p, true),
            route(a, &[first, second], &p, true)
        );
        let mixed = Vote {
            kind: VerifierKind::Deterministic,
            ..first
        };
        assert_eq!(
            route(a, &[first, mixed], &p, true).reason,
            Reason::VerifierIdentityInvalid
        );
        let zero = Vote {
            verifier_id: [0; 32],
            ..first
        };
        assert_eq!(
            route(a, &[zero], &p, true).reason,
            Reason::VerifierIdentityInvalid
        );
        let refuted = Vote {
            outcome: Outcome::Refuted,
            ..first
        };
        assert_eq!(
            route(a, &[first, refuted], &p, true).reason,
            Reason::VerifierConflict
        );
    }
    #[test]
    fn independent_refutation_remains_rejection_at_every_severity_and_confidence() {
        let p = policy();
        let vote = Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Refuted,
            verifier_id: [1; 32],
        };
        for severity in [
            Severity::Info,
            Severity::Low,
            Severity::Medium,
            Severity::High,
            Severity::Critical,
        ] {
            for confidence_permille in 0..=1000 {
                let a = Some(Assessment {
                    severity,
                    confidence_permille,
                });
                assert_eq!(route(a, &[vote], &p, true).decision, Decision::AutoReject);
            }
        }
    }
}

/// Metadata-bound vote. Signature/receipt and registry provenance must be checked
/// by the trusted admission adapter before constructing this input.
#[derive(Debug, Clone, Copy)]
pub struct RegisteredVote {
    pub vote: Vote,
    pub signing_key_id: [u8; 32],
}
/// Registry-aware candidate routing. Never authorizes a transition.
pub fn route_with_registry(
    assessment: Option<Assessment>,
    votes: &[RegisteredVote],
    policy: &Policy,
    source_budget_available: bool,
    registry: &crate::bounty_evidence::VerifierRegistry,
    at: u64,
    min_level: crate::bounty_evidence::AttestationLevel,
) -> ReviewDecision {
    if votes.iter().any(|v| {
        registry
            .authenticate(&v.vote.verifier_id, &v.signing_key_id, at, min_level)
            .is_err()
    }) {
        return ReviewDecision {
            decision: Decision::ReviewRequired,
            reason: Reason::VerifierRegistryRejected,
            policy_digest: policy.policy_digest,
        };
    }
    let raw: Vec<_> = votes.iter().map(|v| v.vote).collect();
    let mut result = route(assessment, &raw, policy, source_budget_available);
    if result.decision == Decision::AutoAccept
        && assessment.is_some_and(|a| severity_rank(a.severity) >= severity_rank(Severity::High))
    {
        let confirmed: Vec<_> = votes
            .iter()
            .filter(|v| v.vote.kind != VerifierKind::Model && v.vote.outcome == Outcome::Confirmed)
            .map(|v| (v.vote.verifier_id, v.signing_key_id))
            .collect();
        if registry.independent_operators(&confirmed, at, min_level)
            < usize::from(policy.required_independent_confirmations.max(1))
        {
            result.decision = Decision::ReviewRequired;
            result.reason = Reason::InsufficientIndependentEvidence;
        }
    }
    result
}

/// Quorum-approved registry snapshot; no caller-supplied authentication timestamp.
/// Registry freshness/rollback bounds remain part of independently pinned checkpoint trust.
pub fn route_with_governed_registry(
    assessment: Option<Assessment>,
    votes: &[RegisteredVote],
    policy: &Policy,
    source_budget_available: bool,
    registry: &crate::bounty_evidence::trust::GovernedVerifierRegistry,
    min_level: crate::bounty_evidence::AttestationLevel,
) -> ReviewDecision {
    route_with_registry(
        assessment,
        votes,
        policy,
        source_budget_available,
        registry.registry(),
        registry.verified_at(),
        min_level,
    )
}
