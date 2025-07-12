{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  check,
  flex,
  pkg-config,
  which,
  elfutils,
  libffi,
  llvm,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = "nvc";
    tag = "r${version}";
    hash = "sha256-W6TCtd6LJwjM/kPBqEiPM2xcWn8OzEjCx4llUR/6K78=";
  };

  nativeBuildInputs = [
    autoreconfHook
    check
    flex
    pkg-config
    which
  ];

  buildInputs =
    [
      libffi
      llvm
      zlib
      zstd
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
      elfutils
    ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = [
    "--enable-vhpi"
    "--disable-lto"
  ];

  doCheck = true;

  meta = with lib; {
    description = "VHDL compiler and simulator";
    mainProgram = "nvc";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
