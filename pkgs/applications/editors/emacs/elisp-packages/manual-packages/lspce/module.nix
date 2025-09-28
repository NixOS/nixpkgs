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
  version = "1.1.0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "45f84ce102bb34e44c39e5f437107ba786973d6f";
    hash = "sha256-DiqC7z1AQbXsSXc77AGRilWi3HfEg0YoHrXu54O3Clo=";
  };

  cargoHash = "sha256-ygFXKniCCOyXndPOTKoRbd4W1OR2CSA2jr7yxpwkw28=";

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
    maintainers = with lib.maintainers; [ ];
  };
}
