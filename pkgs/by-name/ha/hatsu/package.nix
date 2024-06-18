{ cmake
, fetchFromGitHub
, gitUpdater
, lib
, openssl
, pkg-config
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    rev = "v${version}";
    hash = "sha256-gBzhuV0SDmNwl5PkpdGxkMBn5m4vEXfv23WK7+ZzQs8=";
  };

  cargoHash = "sha256-A2tl0jjKODA/qodxkIe/3V4ZDGV4X0myiduJsLtd7r0=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  env = { OPENSSL_NO_VENDOR = true; };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "beta";
  };

  meta = {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    license = lib.licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
}
