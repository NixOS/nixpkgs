use owi_sym::Symbolic;

fn mean_wrong(x: i32, y: i32) -> i32 {
    (x + y) / 2
}

fn mean_correct(x: i32, y: i32) -> i32 {
    (x & y) + ((x ^ y) >> 1)
}

fn main() {
    let x = i32::symbol();
    let y = i32::symbol();
    owi_sym::assert(mean_wrong(x, y) == mean_correct(x, y))
}
