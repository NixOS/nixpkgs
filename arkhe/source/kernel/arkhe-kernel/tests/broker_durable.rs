#![cfg(feature = "sqlite-broker")]
use arkhe_core::Digest32;
use arkhe_kernel::{
    broker::{DispatchJournal, Reservation},
    broker_sqlite::SqliteDispatchJournal,
};
use std::sync::{Arc, Barrier};

#[test]
fn reopen_preserves_success_uncertainty_conflict_and_closed_consumption() {
    let path = std::env::temp_dir().join(format!("arkhe-broker-{}.sqlite", uuid::Uuid::new_v4()));
    let op = Digest32([1; 32]);
    let binding = Digest32([2; 32]);
    let closed = Digest32([3; 32]);
    {
        let mut owner = SqliteDispatchJournal::open(&path).unwrap();
        assert!(matches!(
            owner.reserve_payment("a", op, binding, closed).unwrap(),
            Reservation::Acquired
        ));
        let mut other = SqliteDispatchJournal::open(&path).unwrap();
        assert!(matches!(
            other.reserve_payment("a", op, binding, closed).unwrap(),
            Reservation::Uncertain
        ));
        assert!(other.complete("a", op, binding, b"fake").is_err());
        assert!(other
            .reserve_payment("a", Digest32([4; 32]), binding, closed)
            .is_err());
        owner.complete("a", op, binding, b"receipt").unwrap();
        assert!(owner.complete("a", op, binding, b"second").is_err());
    }
    let mut reopened = SqliteDispatchJournal::open(&path).unwrap();
    assert!(
        matches!(reopened.reserve_payment("a",op,binding,closed).unwrap(),Reservation::Replay(r) if r==b"receipt")
    );
    assert!(reopened
        .reserve_payment("a", op, Digest32([9; 32]), closed)
        .is_err());
    assert!(reopened.reserve_payment("b", op, binding, closed).is_err());
    let uncertain = Digest32([5; 32]);
    assert!(matches!(
        reopened.reserve("a", uncertain, binding).unwrap(),
        Reservation::Acquired
    ));
    drop(reopened);
    let mut reopened = SqliteDispatchJournal::open(&path).unwrap();
    assert!(matches!(
        reopened.reserve("a", uncertain, binding).unwrap(),
        Reservation::Uncertain
    ));
    assert!(reopened
        .complete("a", uncertain, binding, b"invented")
        .is_err());
    drop(reopened);
    std::fs::remove_file(path).unwrap();
}

#[test]
fn independent_connections_cannot_reserve_the_same_slot_twice() {
    let path = std::env::temp_dir().join(format!("arkhe-broker-{}.sqlite", uuid::Uuid::new_v4()));
    drop(SqliteDispatchJournal::open(&path).unwrap());
    let barrier = Arc::new(Barrier::new(2));
    let handles: Vec<_> = (0..2)
        .map(|_| {
            let path = path.clone();
            let barrier = barrier.clone();
            std::thread::spawn(move || {
                let mut journal = SqliteDispatchJournal::open(&path).unwrap();
                barrier.wait();
                matches!(
                    journal
                        .reserve_payment(
                            "a",
                            Digest32([1; 32]),
                            Digest32([2; 32]),
                            Digest32([3; 32])
                        )
                        .unwrap(),
                    Reservation::Acquired
                )
            })
        })
        .collect();
    assert_eq!(
        handles
            .into_iter()
            .map(|h| usize::from(h.join().unwrap()))
            .sum::<usize>(),
        1
    );
    std::fs::remove_file(path).unwrap();
}
