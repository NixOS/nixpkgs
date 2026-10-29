use arkhe_verify_core::hash::blake3_256;

#[test]
fn blake3_known_answers() {
    assert_eq!(
        hex::encode(blake3_256(b"")),
        "af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262"
    );
    assert_eq!(
        hex::encode(blake3_256(b"abc")),
        "6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85"
    );
}
