use arkhe_core::canonical::{encode_map_with_bytes, encode_value};
use serde_json::{json, Map};

#[test]
fn typed_bytes_match_literal_cbor_and_maps_ignore_insertion_order() {
    // {"a": h'001718ff', "z": [0, 255]}: bytes and ordinary array coexist.
    let fields = json!({"z": [0, 255]});
    let encoded =
        encode_map_with_bytes(fields.as_object().unwrap(), &[("a", &[0, 23, 24, 255])]).unwrap();
    assert_eq!(
        encoded,
        [0xa2, 0x61, b'a', 0x44, 0, 23, 24, 255, 0x61, b'z', 0x82, 0, 0x18, 0xff]
    );
    let a = encode_map_with_bytes(&Map::new(), &[("z", b"last"), ("a", b"first")]).unwrap();
    let b = encode_map_with_bytes(&Map::new(), &[("a", b"first"), ("z", b"last")]).unwrap();
    assert_eq!(a, b);
    // The old generic encoder retains arrays, including identically named fields.
    assert_eq!(
        encode_value(&json!({"request_bytes": [0, 255]})),
        [
            vec![0xa1, 0x6d],
            b"request_bytes".to_vec(),
            vec![0x82, 0, 0x18, 0xff]
        ]
        .concat()
    );
}

#[test]
fn byte_string_length_headers_use_shortest_encoding() {
    for (size, header) in [
        (0, vec![0x40]),
        (23, vec![0x57]),
        (24, vec![0x58, 24]),
        (255, vec![0x58, 255]),
        (256, vec![0x59, 1, 0]),
        (65535, vec![0x59, 255, 255]),
        (65536, vec![0x5a, 0, 1, 0, 0]),
    ] {
        let payload = vec![0xff; size];
        let result = encode_map_with_bytes(&Map::new(), &[("b", &payload)]).unwrap();
        assert_eq!(&result[..3], &[0xa1, 0x61, b'b']);
        assert_eq!(&result[3..3 + header.len()], header.as_slice());
        assert_eq!(&result[3 + header.len()..], payload.as_slice());
    }
}

#[test]
fn duplicate_keys_cannot_create_ambiguous_cbor() {
    let fields = json!({"a": null});
    assert_eq!(
        encode_map_with_bytes(fields.as_object().unwrap(), &[("a", b"x")]),
        Err("duplicate canonical map key")
    );
    assert_eq!(
        encode_map_with_bytes(&Map::new(), &[("a", b"x"), ("a", b"y")]),
        Err("duplicate canonical map key")
    );
    assert_eq!(
        encode_map_with_bytes(fields.as_object().unwrap(), &[]).unwrap(),
        encode_value(&fields)
    );
}
