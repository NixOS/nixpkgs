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
  version = "20260813";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    sha256 = "sha256-8FSPHOK5/2nSpb8qSOXY/SdtkWfpzNKMq9pm8wL7UCg=";
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
