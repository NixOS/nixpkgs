use arkhe_sql::mmr::profile::{mmr_size, PROFILE_DIGEST_HEX};

#[test]
fn frozen_profile_digest_is_exact() {
    assert_eq!(
        PROFILE_DIGEST_HEX,
        "bcd07a275061ef385fccdd184030c2358fdd0937477cb0ef30cf8148342f2450"
    );
}

#[test]
fn mmr_size_matches_frozen_profile_examples() {
    assert_eq!(mmr_size(1), 1);
    assert_eq!(mmr_size(3), 4);
    assert_eq!(mmr_size(4), 7);
    assert_eq!(mmr_size(5), 8);
    assert_eq!(mmr_size(7), 11);
}
