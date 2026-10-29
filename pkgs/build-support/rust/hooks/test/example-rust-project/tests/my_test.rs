use hello::hello;

#[test]
fn test_hello() {
    assert_eq!(hello::hello(), "Hello, world!");
}
