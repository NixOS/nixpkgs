{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  intltool,
  json_c,
  libtool,
  pkg-config,
  python3,
  gettext,
  autoreconfHook,
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

  patches = [
    # glib gettext macros are broken/obsolete,
    # so we patch libmypaint to use regular gettext instead.
    ./0001-configure-use-regular-GETTEXT-unconditionally.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
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

  # don't rely on rigid autotools versions, instead preload whatever is in $PATH in the build environment.
  # libmypaint 1.6.1 only officially supports autotools up to 1.16,
  # 2.0.0 alphas support up to autotools 1.17.
  # However, we are now on autotools 1.18, so this would otherwise break.
  preConfigure = ''
    export AUTOMAKE=automake
    export ACLOCAL=aclocal
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "http://mypaint.org/";
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = licenses.isc;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
