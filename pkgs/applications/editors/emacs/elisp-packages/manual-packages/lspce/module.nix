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
  version = "1.1.0-unstable-2024-07-14";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "fd320476df89cfd5d10f1b70303c891d3b1e3c81";
    hash = "sha256-KnERYq/CvJhJIdQkpH/m82t9KFMapPl+CyZkYyujslU=";
  };

  cargoHash = "sha256-I2OobRu1hc6xc4bRrIO1FImPYBbFy1jXPcTsivbbskk=";

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
