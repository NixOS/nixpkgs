use arkhe_verify_core::policy::*;
use proptest::prelude::*;
use std::collections::BTreeSet;

fn v1() -> Policy {
    Policy {
        policy_id: "v1".into(),
        max_amount_cents: 100_000,
        allowed: BTreeSet::from([
            ("mod-a".into(), "1.0.0".into()),
            ("mod-a".into(), "2.0.0".into()),
            ("mod-b".into(), "3.0.0".into()),
        ]),
    }
}
fn allowed_request(old: &Policy) -> impl Strategy<Value = Action> {
    let pairs: Vec<_> = old.allowed.iter().cloned().collect();
    (
        "[a-z0-9]{1,16}",
        0..=old.max_amount_cents,
        prop::sample::select(pairs),
        prop::collection::vec(any::<u8>(), 0..64),
    )
        .prop_map(
            |(operation_id, amount_cents, (module_id, module_version), payload)| Action {
                operation_id,
                amount_cents,
                module_id,
                module_version,
                payload,
            },
        )
}
fn removal(old: &Policy, new: &Policy) -> VersionRestriction {
    VersionRestriction {
        old_policy: old.digest(),
        new_policy: new.digest(),
        module_id: "mod-a".into(),
        removed_version: "2.0.0".into(),
        reason: "explicit migration: retire reviewed vulnerable module version".into(),
    }
}

proptest! {
    #![proptest_config(ProptestConfig::with_cases(10_000))]
    #[test]
    fn compatible_expansion_for_10000_allowed_requests(r in allowed_request(&v1())) {
        let old = v1(); let mut new = old.clone(); new.policy_id = "v2-compatible".into(); new.max_amount_cents += 1;
        prop_assert!(old.permits_action(&r));
        prop_assert!(compatible_for(&old,&new,&r,&[]));
    }
    #[test]
    fn explicitly_justified_removal_for_10000_allowed_requests(r in allowed_request(&v1())) {
        let old = v1(); let mut new = old.clone(); new.policy_id="v2-restricted".into(); new.allowed.remove(&("mod-a".into(),"2.0.0".into()));
        prop_assert!(old.permits_action(&r));
        prop_assert!(compatible_for(&old,&new,&r,&[removal(&old,&new)]));
    }
}

#[test]
fn unjustified_restriction_has_deterministic_counterexample() {
    let old = v1();
    let mut new = old.clone();
    new.allowed.remove(&("mod-b".into(), "3.0.0".into()));
    let r = Action {
        operation_id: "counterexample".into(),
        amount_cents: 50_000,
        module_id: "mod-b".into(),
        module_version: "3.0.0".into(),
        payload: vec![],
    };
    assert!(old.permits_action(&r));
    assert!(!new.permits_action(&r));
    assert!(!compatible_for(&old, &new, &r, &[]));
}

#[test]
fn migration_reason_never_grants_runtime_access_or_relaxes_spending() {
    let old = v1();
    let mut new = old.clone();
    new.allowed.remove(&("mod-a".into(), "2.0.0".into()));
    let r = Action {
        operation_id: "op".into(),
        amount_cents: 50_000,
        module_id: "mod-a".into(),
        module_version: "2.0.0".into(),
        payload: vec![],
    };
    let reason = removal(&old, &new);
    assert!(compatible_for(&old, &new, &r, std::slice::from_ref(&reason)));
    assert!(!new.permits_action(&r));
    new.max_amount_cents = 49_999;
    assert!(!compatible_for(&old, &new, &r, &[removal(&old, &new)]));
    let mut wrong = reason;
    wrong.reason.clear();
    assert!(!compatible_for(&old, &new, &r, &[wrong]));
}
