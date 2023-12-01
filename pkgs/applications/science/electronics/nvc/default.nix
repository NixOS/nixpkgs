{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, check
, elfutils
, flex
, libffi
, llvm
, pkg-config
, which
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
    elfutils
    libffi
    llvm
    zlib
    zstd
  ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = [
    "--disable-lto"
  ];
  dontDisableStatic = true;

  doCheck = true;

  meta = with lib; {
    description = "VHDL compiler and simulator";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
