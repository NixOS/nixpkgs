{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  version = "0.21.0";
in
rustPlatform.buildRustPackage {
  pname = "gir";
  inherit version;

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = version;
    sha256 = "sha256-fjfTB621DwnCRXTsoGxISk+4XblMbjX5dzY+M8uDZ80=";
  };

  cargoHash = "sha256-wT09qXGx4+oJ9MhZqpG9jZ1yMYT/JJ2bJ6z1CT7wqUQ=";

  postPatch = ''
    rm build.rs
    sed -i '/build = "build\.rs"/d' Cargo.toml
    echo "pub const VERSION: &str = \"$version\";" > src/gir_version.rs
  '';

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    mainProgram = "gir";
  };
}
