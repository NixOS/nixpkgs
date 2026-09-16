fn main() {
    let mut buffer = itoa::Buffer::new();
    println!("{}", buffer.format(42));
}
