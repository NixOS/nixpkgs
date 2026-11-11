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
  version = "20261026";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    sha256 = "sha256-t+fepYO7TaX2CS7n5moT6j1xiuXN6Q6wWmrNdLszbT4=";
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
