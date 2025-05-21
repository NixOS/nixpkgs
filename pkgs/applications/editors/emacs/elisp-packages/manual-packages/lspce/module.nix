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
  version = "1.1.0-unstable-2024-07-29";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "e954e4d77aeb45deb14182631f3d5aa9bcc9e587";
    hash = "sha256-9AUffkdgvVbHRIrHQPVl36plIfGxf3vsN9JCuFe0P6Q=";
  };

  cargoHash = "sha256-wrrdXX/rEVxmHdyblm4I9iHD3bPoDd1KlBe3ODeGFeM=";

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
