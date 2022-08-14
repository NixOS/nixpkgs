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
, llvm
, zlib
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-U9VxpHzrAQPMqnSs0YcEnc9dlQUutTuZCJP5F1v7eaA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    check
    flex
    pkg-config
    which
  ];

  buildInputs = [
    llvm
    zlib
  ] ++ [
    (if stdenv.isLinux then elfutils else libelf)
  ];

  # TODO: recheck me on next release
  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i "/vhpi4/d" test/regress/testlist.txt
  '';

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ wegank ];
  };
}
