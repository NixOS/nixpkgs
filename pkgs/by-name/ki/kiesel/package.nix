{
  lib,
  stdenv,
  callPackage,
  fetchFromGitea,
  zig,
  cargo,
  rustPlatform,
}:

stdenv.mkDerivation rec {
  pname = "kiesel";
  version = "0-unstable-2025-08-16";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "kiesel-js";
    repo = "kiesel";
    rev = "32ec6ca21330e0ee344d71b937ca6d52292cd8c2";
    hash = "sha256-zxfwEZYpcMF6eps1nyplL2v/XMxyL9YVI0P/TOvaCbI=";
  };

  # zement is a Rust crate using other Rust deps; need to vendor those, too
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/pkg/zement";
    hash = "sha256-yIgz3rXttq0jebor3LzfYSHjcl3W6kzazQTqWLrZm6I=";
  };

  patches = [
    ./0001-hack-never-build-std.patch
  ];

  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p

    # manually doing what the helper scripts for rust would (since this is, well, Zig)
    pushd pkg/zement
      mkdir -p .cargo
      cat $cargoDeps/.cargo/config.toml >> .cargo/config.toml
      ln -s $cargoDeps @vendor@
    popd
  '';

  nativeBuildInputs = [
    cargo
    zig.hook
  ];

  meta = with lib; {
    description = "A JavaScript engine written in Zig";
    homepage = "https://kiesel.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ multisn8 ];
    mainProgram = "kiesel";
  };
}
