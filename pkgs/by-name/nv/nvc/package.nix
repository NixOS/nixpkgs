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
  apple-sdk_11,
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = "nvc";
    rev = "r${version}";
    hash = "sha256-ppZ6rvSmny4wKCpdlJvvaLOTUn3/hUAiEhEkj33oF3c=";
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
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
