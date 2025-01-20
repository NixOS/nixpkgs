{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpng,
  zlib,
  lcms2,
}:

rustPlatform.buildRustPackage rec {
  pname = "pngquant";
  version = "3.0.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "pngquant";
    rev = version;
    hash = "sha256-u2zEp9Llo+c/+1QGW4V4r40KQn/ATHCTEsrpy7bRf/I=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-mZpg6BRpsvEiMsS6ZJzVYg6wXHLb3Cf72sK1yzTF8y4=";
  cargoPatches = [
    # https://github.com/kornelski/pngquant/issues/347
    ./add-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpng
    zlib
    lcms2
  ];

  doCheck = false; # Has no Rust-based tests

  postInstall = ''
    install -Dpm0444 pngquant.1 $man/share/man/man1/pngquant.1
  '';

  meta = with lib; {
    homepage = "https://pngquant.org/";
    description = "Tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    changelog = "https://github.com/kornelski/pngquant/raw/${version}/CHANGELOG";
    platforms = platforms.unix;
    license = with licenses; [
      gpl3Plus
      hpnd
      bsd2
    ];
    mainProgram = "pngquant";
    maintainers = [ ];
  };
}
