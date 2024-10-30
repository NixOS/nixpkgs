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
  version = "1.1.0-unstable-2024-09-07";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "4bf1fa9d3d8b17eb6ae628e93018ee8f020565ba";
    hash = "sha256-OeDUQXqVBUfKjYt5oSmfl2N/19PFYIbPXfFqloai0LQ=";
  };

  cargoHash = "sha256-VMGdB4dF3Ccxl6DifdXFH4+XVT7RoeqI/l/AR/epg4o=";

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
