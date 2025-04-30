{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  python3,
  xorg,
  cmake,
  libgit2,
  curl,
  writableTmpDirAsHomeHook,
  gitMinimal,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = "amp";
    tag = version;
    hash = "sha256-YK+HSWTtSVLK8n7NDiif3bBqp/dQW2UTYo3yYcZ5cIA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6enFOmIAYOgOdoeA+pk37+BobI5AGPBxjp73Gd4C+gI=";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    gitMinimal
  ];
  buildInputs = [
    openssl
    xorg.libxcb
    libgit2
    zlib
  ];

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
