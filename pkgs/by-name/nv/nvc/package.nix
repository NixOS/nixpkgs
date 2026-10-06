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

stdenv.mkDerivation (finalAttrs: {
  pname = "nvc";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = "nvc";
    tag = "r${finalAttrs.version}";
    hash = "sha256-1L7IdncoQ1H6e51Bikmjnw8XLse+ttUgrI/0/h+Q56Q=";
  };

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

  meta = {
    description = "VHDL compiler and simulator";
    mainProgram = "nvc";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
