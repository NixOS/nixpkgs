{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  python3,
  xorg,
  cmake,
  libgit2,
  darwin,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = "amp";
    rev = version;
    hash = "sha256-xNadwz2agPbxvgUqrUf1+KsWTmeNh8hJIWcNwTzzM/M=";
  };

  cargoPatches = [ ./update_time_crate.patch ];

  cargoHash = "sha256-EYD1gQgkHemT/3VewdsU5kOGQKY3OjIHRiTSqSRNwtU=";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
  buildInputs =
    [
      openssl
      xorg.libxcb
      libgit2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        curl
        Security
        AppKit
      ]
    );

  # Tests need to write to the theme directory in HOME.
  preCheck = "export HOME=`mktemp -d`";

  meta = {
    description = "Modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sb0
      aleksana
    ];
    mainProgram = "amp";
  };
}
