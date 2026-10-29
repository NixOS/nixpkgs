pub const PROFILE_ID: &str = "arkhe-mmr";
pub const PROFILE_VERSION: u16 = 1;
pub const PROFILE_DIGEST_HEX: &str =
    "bcd07a275061ef385fccdd184030c2358fdd0937477cb0ef30cf8148342f2450";

pub fn mmr_size(leaf_count: u64) -> u64 {
    2 * leaf_count - leaf_count.count_ones() as u64
}
