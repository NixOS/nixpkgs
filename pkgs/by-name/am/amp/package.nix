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
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = "amp";
    tag = version;
    hash = "sha256-xNadwz2agPbxvgUqrUf1+KsWTmeNh8hJIWcNwTzzM/M=";
  };

  cargoPatches = [ ./update_time_crate.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-4lYywaPTfoOHEYHy+h7HfWn+OaDdk166tQ8ZFx9XZK0=";

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

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

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
