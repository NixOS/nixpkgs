{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, check
, flex
, pkg-config
, which
, elfutils
, libelf
, libffi
, llvm
, zlib
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-UeA+6RKZMttLThyAf80ONximXRJNw5mUNM+cyCDTcGM=";
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
  ] ++ lib.optionals stdenv.isLinux [
    elfutils
  ] ++ lib.optionals (!stdenv.isLinux) [
    libelf
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
    homepage = "https://www.nickg.me.uk/nvc/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
