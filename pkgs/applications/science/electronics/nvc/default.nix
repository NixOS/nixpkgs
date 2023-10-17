{ lib
, stdenv
, fetchFromGitHub
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
, zstd
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.10.4";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = "nvc";
    rev = "r${version}";
    hash = "sha256-f4VjSBoJnsGb8MHKegJDlomPG32DuTgFcyv1w0GxKvA=";
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
