{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitu";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-hN7Dj31t1Kh9m4Ou/yBALqEKVlKB0++Qu1H5UEiIUzs=";
  };

  cargoHash = "sha256-gMSEaXoHK6hrZ2zrHOZkRgve66Zg1gshB3KqUjfxtnI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

  meta = with lib; {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
}
