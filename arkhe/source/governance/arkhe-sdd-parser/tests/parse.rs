use arkhe_governance::constitution_graph::Modality;
use arkhe_sdd_parser::{
    detect_format, parse_spec, parse_tasks, CriterionKind, Severity, SpecFormat,
};

const KIRO_SPEC: &str = "# Requirements

### Requirement 1

**User Story:** As a user, I want MFA, so that my account is safe.

#### Acceptance Criteria

1. WHEN a user submits valid credentials THEN the system SHALL require a second factor
2. IF the second factor is wrong three times, THE system SHALL lock the account
3. THE system SHALL NOT store the second factor in plain text

### Requirement 2

1. WHILE the account is locked, WHEN the user requests a reset, THE system SHALL send a recovery email
";

const KIRO_TASKS: &str = "- [ ] 1. Implement MFA
  - [ ] 1.1 Prompt for second factor
    - _Requirements: 1.1_
  - [ ] 1.2 Lockout and storage
    - _Requirements: 1.2, 1.3_
- [ ] 2. Recovery email
  - _Requirements: 2.1_
";

#[test]
fn kiro_ears_templates() {
    let c = parse_spec(KIRO_SPEC, None).expect("parses");
    assert_eq!(c.format, SpecFormat::Ears);
    let ids: Vec<_> = c.invariants.iter().map(|i| i.id.as_str()).collect();
    assert_eq!(ids, ["1.1", "1.2", "1.3", "2.1"]);
    let i = &c.invariants[0];
    assert_eq!((i.kind, i.modality), (CriterionKind::EventDriven, Modality::Obligatory));
    assert_eq!(i.subject, "system");
    assert_eq!(i.response, "require a second factor");
    assert_eq!(i.conditions[0].text, "a user submits valid credentials");
    assert_eq!(c.invariants[1].kind, CriterionKind::Unwanted);
    assert_eq!(c.invariants[2].modality, Modality::Impermissible);
    assert_eq!(c.invariants[2].kind, CriterionKind::Ubiquitous);
    assert_eq!(c.invariants[3].kind, CriterionKind::Complex);
    assert_eq!(c.invariants[3].specificity(), 2);
}

#[test]
fn kiro_tasks_satisfy_v1() {
    let c = parse_spec(KIRO_SPEC, None).unwrap();
    let (set, diags) = parse_tasks(KIRO_TASKS, &c);
    assert!(diags.is_empty(), "{diags:?}");
    assert!(set.v1_satisfied());
    let t = set.tasks.iter().find(|t| t.task_id == "1.2").unwrap();
    assert_eq!(t.refs, ["1.2", "1.3"]);
    assert!(set.tasks.iter().find(|t| t.task_id == "1").unwrap().is_group);
}

#[test]
fn multiline_portuguese_criterion() {
    let spec = "### Requirement: Login deve exigir MFA\nWHEN um utilizador faz login\nTHE SYSTEM SHALL exigir um segundo fator\n";
    let c = parse_spec(spec, None).unwrap();
    let i = &c.invariants[0];
    assert_eq!(i.id, "login-deve-exigir-mfa.1");
    assert_eq!(i.subject, "SYSTEM");
    assert_eq!(i.conditions[0].text, "um utilizador faz login");
    assert_eq!(i.response, "exigir um segundo fator");
}

#[test]
fn malformed_ears_fails_closed() {
    let errs = parse_spec("WHEN x happens the system SHALL do y\n", None).unwrap_err();
    assert_eq!(errs[0].code, "malformed_ears");
    let errs = parse_spec("Notes: this SHALL be revisited\n", None).unwrap_err();
    assert_eq!(errs[0].code, "malformed_ears");
    let errs = parse_spec("THE system SHALL a and SHALL b\n", None).unwrap_err();
    assert_eq!(errs[0].code, "multiple_shall");
}

#[test]
fn deontic_conflict_detected() {
    let spec = "1. THE system SHALL log the token\n2. THE system SHALL NOT log the token\n";
    let errs = parse_spec(spec, None).unwrap_err();
    assert!(errs.iter().any(|e| e.code == "deontic_conflict"));
}

const SPEC_KIT: &str = "# Feature Specification: Checkout

### User Story 1 - Pay by card (Priority: P1)

**Acceptance Scenarios**:

1. **Given** a cart with items, **When** the user pays, **Then** an order is created
2. **Given** a declined card, **When** the user pays, **Then** no order is created

### Functional Requirements

- **FR-001**: System MUST validate the card before charging
- **FR-002**: System MUST NOT persist the full card number
";

#[test]
fn spec_kit_gwt_and_fr() {
    let c = parse_spec(SPEC_KIT, None).unwrap();
    assert_eq!(c.format, SpecFormat::GivenWhenThen);
    let ids: Vec<_> = c.invariants.iter().map(|i| i.id.as_str()).collect();
    assert_eq!(ids, ["FR-001", "FR-002", "US1.AS1", "US1.AS2"]);
    assert_eq!(c.invariants[1].modality, Modality::Impermissible);
    assert_eq!(c.invariants[2].conditions[0].text, "a cart with items");
    assert_eq!(c.invariants[2].response, "an order is created");
}

#[test]
fn spec_kit_tasks_and_findings() {
    let c = parse_spec(SPEC_KIT, None).unwrap();
    let tasks = "- [ ] T001 Setup project\n- [ ] T002 [P] [US1] Checkout flow per FR-001\n- [ ] T003 Mask card FR-009\n";
    let (set, diags) = parse_tasks(tasks, &c);
    assert!(!set.v1_satisfied());
    let codes: Vec<_> = diags.iter().map(|d| (d.code, d.severity)).collect();
    assert!(codes.contains(&("v1_unmapped_task", Severity::Finding)));
    assert!(codes.contains(&("unknown_reference", Severity::Error)));
    assert!(codes.contains(&("uncovered_criterion", Severity::Finding)));
    let t2 = set.tasks.iter().find(|t| t.task_id == "T002").unwrap();
    assert_eq!(t2.refs, ["FR-001", "US1.AS1", "US1.AS2"]);
}

#[test]
fn needs_clarification_is_an_error() {
    let spec = format!("{SPEC_KIT}- **FR-003**: System MUST retain logs [NEEDS CLARIFICATION: how long?]\n");
    let errs = parse_spec(&spec, None).unwrap_err();
    assert!(errs.iter().any(|e| e.code == "needs_clarification"));
}

#[test]
fn mixed_format_requires_explicit_choice() {
    let spec = format!("{SPEC_KIT}\n1. THE system SHALL log\n");
    assert_eq!(detect_format(&spec).unwrap_err().code, "ambiguous_format");
}

#[test]
fn digests_are_stable_across_line_endings_and_whitespace() {
    let a = parse_spec(KIRO_SPEC, None).unwrap();
    let crlf = KIRO_SPEC.replace('\n', "\r\n").replace("require a second", "require  a   second");
    let b = parse_spec(&crlf, None).unwrap();
    assert_eq!(a.canonical_bytes(), b.canonical_bytes());
    assert_eq!(a.digest(), b.digest());
    let edited = KIRO_SPEC.replace("second factor\n", "third factor\n");
    assert_ne!(a.digest(), parse_spec(&edited, None).unwrap().digest());
}

#[test]
fn task_maps_to_protected_implement_work_intent() {
    use arkhe_core::work::{ContextKind, WorkIntentType};
    let c = parse_spec(KIRO_SPEC, None).unwrap();
    let (set, _) = parse_tasks(KIRO_TASKS, &c);
    let task = |id: &str| set.tasks.iter().find(|t| t.task_id == id).unwrap();
    let w = task("1.1").to_work_intent(set.constitution, "agent:claude", b"req-1", 1_700_000_000);
    assert_eq!(w.intent_type, WorkIntentType::Implement);
    assert_eq!(w.context[0].kind, ContextKind::Policy);
    assert_eq!(w.context[0].hash, c.digest());
    assert_ne!(w.target, task("1.2").target(set.constitution));
    // Same task under an edited spec is a different target and different parameters.
    let edited = parse_spec(&KIRO_SPEC.replace("send a recovery", "send a reset"), None).unwrap();
    assert_ne!(w.target, task("1.1").target(edited.digest()));
    assert_ne!(w.parameters_digest, task("1.1").parameters_digest(edited.digest()));
    // Deterministic: same inputs, same canonical WorkIntent digest.
    let again = task("1.1").to_work_intent(set.constitution, "agent:claude", b"req-1", 1_700_000_000);
    assert_eq!(w.digest(), again.digest());
    assert!(matches!(
        arkhe_kernel::classify(&w.intent_type),
        arkhe_kernel::Classification::Protected
    ));
}

#[test]
fn canonical_bytes_are_cbor_maps_with_byte_digests() {
    let c = parse_spec(KIRO_SPEC, None).unwrap();
    let bytes = c.canonical_bytes();
    assert_eq!(bytes[0], 0xa2, "top-level map of two entries");
    let (set, _) = parse_tasks(KIRO_TASKS, &c);
    let tb = set.canonical_bytes();
    // "policy_digest" key followed by a 32-byte bstr (0x58 0x20).
    let key = b"mpolicy_digest";
    let at = tb.windows(key.len()).position(|w| w == key).unwrap();
    assert_eq!(&tb[at + key.len()..at + key.len() + 2], &[0x58, 0x20]);
}
