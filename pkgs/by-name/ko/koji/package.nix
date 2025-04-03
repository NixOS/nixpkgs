{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  perl,
  udev,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "koji";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "its-danny";
    repo = "koji";
    rev = version;
    hash = "sha256-2kBjHX7izo4loJ8oyPjE9FtCvUODC3Sm4T8ETIdeGZM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZHti7nMfHiYur1kjxj+ySIF4/l0UU9q2urabUWZyk6E=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    perl
    udev
  ];

  buildInputs = [
    openssl.dev
  ];

  meta = {
    description = "Interactive CLI for creating conventional commits";
    homepage = "https://github.com/its-danny/koji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ByteSudoer
      WeetHet
    ];
    mainProgram = "koji";
    platforms = lib.platforms.unix;
  };
}
