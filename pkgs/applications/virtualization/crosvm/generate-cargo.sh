dir="$(mktemp -d)" &&
    cd "$dir" &&
    unpackPhase &&
    cd "${sourceRoot:-}" &&
    cargo generate-lockfile &&
    mv Cargo.lock "$1"
rm -rf "$dir"
