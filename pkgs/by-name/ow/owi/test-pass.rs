use owi_sym::Symbolic;

fn mean_one(x: i32, y: i32) -> i32 {
    (x + y)/2
}

fn mean_two(x: i32, y: i32) -> i32 {
    (y + x)/2
}

fn main() {
    let x = i32::symbol();
    let y = i32::symbol();
    // proving the commutative property of addition!
    owi_sym::assert(mean_one(x, y) == mean_two(x, y))
}
