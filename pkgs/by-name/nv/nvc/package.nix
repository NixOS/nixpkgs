{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/nickg/nvc/commit/4a94efdb8f314732d59368ade364d2e03b424e14.patch?full_index=1";
      hash = "sha256-faL+/CtqgLitHAol7JYW0dxOXZrm3dwVwiZ8FGPEhgg=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    check
    flex
    pkg-config
    which
  ];

  buildInputs = [
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
