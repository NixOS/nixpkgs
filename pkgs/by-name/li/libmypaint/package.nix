{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  glib,
  intltool,
  json_c,
  libtool,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libmypaint";
  version = "1.6.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "libmypaint";
    rev = "v${version}";
    sha256 = "1ppgpmnhph9h8ayx9776f79a0bxbdszfw9c6bw7c3ffy2yk40178";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    glib # AM_GLIB_GNU_GETTEXT
    intltool
    libtool
    pkg-config
    python3
  ];

  buildInputs = [
    glib
  ];

  # for libmypaint.pc
  propagatedBuildInputs = [
    json_c
  ];

  doCheck = true;

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "http://mypaint.org/";
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = licenses.isc;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
