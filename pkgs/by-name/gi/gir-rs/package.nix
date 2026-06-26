{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  version = "0.22.1";
in
rustPlatform.buildRustPackage {
  pname = "gir";
  inherit version;

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = version;
    sha256 = "sha256-bR6tOKHJk6tG/Q41F4ZaqCo/LjCigRXpFQn1o+AlTbM=";
  };

  cargoHash = "sha256-5FXw78dQJRkBVCn4hhU7+0kZ4pIYDsMAHwH5WrVwxuI=";

  postPatch = ''
    rm build.rs
    sed -i '/build = "build\.rs"/d' Cargo.toml
    echo "pub const VERSION: &str = \"$version\";" > src/gir_version.rs
  '';

  meta = {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "gir";
  };
}
