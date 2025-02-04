{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  version = "0.17.1";
in
rustPlatform.buildRustPackage {
  pname = "gir";
  inherit version;

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = version;
    sha256 = "sha256-WpTyT62bykq/uwzBFQXeJ1HxR1a2vKmtid8YAzk7J+Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustdoc-stripper-0.1.18" = "sha256-b+RRXJDGULEvkIZDBzU/ZchVF63pX0S9hBupeP12CkU=";
    };
  };

  postPatch = ''
    rm build.rs
    sed -i '/build = "build\.rs"/d' Cargo.toml
    echo "pub const VERSION: &str = \"$version\";" > src/gir_version.rs
  '';

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gir";
  };
}
