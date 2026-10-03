{
  lib,
  stdenv,
  autoconf,
  automake,
  libtool,
  intltool,
  ddccontrol-dbgen,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddccontrol-db";
  version = "20260928";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    hash = "sha256-JpHarxvL147ATcvYLR1nxfMY24Pp2TYJlEXG9L1vqSo=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    ddccontrol-dbgen
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
