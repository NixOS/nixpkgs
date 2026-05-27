fn main() {
    println!("{}", cargo_test_support::t!(Result::<&str, &str>::Ok("msg")));
}
