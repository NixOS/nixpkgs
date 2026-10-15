{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "mypaint-brushes";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint-brushes";
    rev = "v${version}";
    hash = "sha256-ide7lD5HwBKq/ZHtAoZHC8OjjV4w9VxhI8Lfv0f4mE0=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://mypaint.org/";
    description = "Brushes used by MyPaint and other software using libmypaint";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
}
