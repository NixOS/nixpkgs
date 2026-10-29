fn main() {
    println!("cargo:rerun-if-changed=../../storage/sql/migrations");
}
