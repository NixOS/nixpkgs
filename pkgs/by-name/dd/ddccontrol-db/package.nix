{
  lib,
  stdenv,
  autoconf,
  automake,
  libtool,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddccontrol-db";
  version = "20260518";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    sha256 = "sha256-/QAOeL1FruxklcWQfoysO1+WzCJB5v/wi81spO6V/Y8=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pakhfn
      doronbehar
    ];
  };
})
