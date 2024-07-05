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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    rev = "v${version}";
    hash = "sha256-4x41Ez2Rq4Bs39LN4qRluDieHx+9bS+GCjvS/cQK84Y=";
  };

  cargoHash = "sha256-hOQ8/m4TY18ZFmLFxxnXUX1yr52tKNmebx6H0uIIGUo=";

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
