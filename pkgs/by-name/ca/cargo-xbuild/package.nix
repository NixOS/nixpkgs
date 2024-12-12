{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-29rCjmzxxIjR5nBN2J3xxP+r8NnPIJV90FkSQQEBbo4=";
  };

  cargoHash = "sha256-tyPhKWDSDNxQy+vpWNS5VP5D8TkUR7MJSAlG8wZsDy4=";

  meta = with lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      johntitor
      xrelkd
    ];
  };
}
