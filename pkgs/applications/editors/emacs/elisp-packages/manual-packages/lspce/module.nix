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
  version = "0.3.0-unstable-2024-08-31";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "faf8aa0f6b575a75b6f248368827c0605905e47e";
    hash = "sha256-31Ps+5xxMFiBcThD4Xq9JQsI9dZS9cafvjDon8RVAco=";
  };

  cargoHash = "sha256-Mws8oxGisc2I542q1a8Y/7Bj3Xbq7Wb42Czr8Z+J4wc=";

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
