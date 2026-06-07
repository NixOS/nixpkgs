use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();

    // Always draw zero :).
    let roll: u8 = rng.gen_range(0..1);
    assert_eq!(roll, 0);
}
