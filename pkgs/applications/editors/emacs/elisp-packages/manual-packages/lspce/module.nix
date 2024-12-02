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
  version = "1.1.0-unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "2a06232033478757dc5770dc7ba658848073de42";
    hash = "sha256-iCge/m1z4Tl3dDvbN4FGsINWE5GEtLxTlvBBu8Zxhzs=";
  };

  cargoHash = "sha256-I3NxV0uIwQ/Vg9Txfx+ouA6FXOYyLQ2kKdhnAdkNfdE=";

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
