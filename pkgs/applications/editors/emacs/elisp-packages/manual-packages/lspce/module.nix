{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
rustPlatform.buildRustPackage {
  pname = "lspce-module";
  version = "0.3.0-unstable-2024-08-24";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "3c82140d31957e6ef8c15dba2afb15974021688a";
    hash = "sha256-1locQgxWVKX2aLZUhmXSlP9luddIPtPS3qTQhgRoocE=";
  };

  cargoHash = "sha256-8fXf5d7PG4+IJdXA5okJlC10K1pl6fqtaeAtAug48Z8=";

  checkFlags = [
    # flaky test
    "--skip=msg::tests::serialize_request_with_null_params"
  ];

  postInstall = ''
    mv --verbose $out/lib/liblspce_module${libExt} $out/lib/lspce-module${libExt}
  '';

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using Rust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
