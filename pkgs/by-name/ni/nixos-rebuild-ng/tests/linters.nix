{
  runCommand,
  python3,
  nixos-rebuild-ng,
}:

runCommand "lint-nixos-rebuild-ng"
  {
    nativeBuildInputs = [
      (python3.withPackages (ps: [
        ps.mypy
        ps.ruff
      ]))
    ];
  }
  ''
    export MYPY_CACHE_DIR="$(mktemp -d)"
    export RUFF_CACHE_DIR="$(mktemp -d)"

    pushd ${nixos-rebuild-ng.src}
    echo -e "\x1b[32m## run mypy\x1b[0m"
    mypy .
    echo -e "\x1b[32m## run ruff\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check .
    popd

    touch $out
  ''
