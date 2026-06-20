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
  version = "20260610";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    sha256 = "sha256-/3TWnBHPP3SyrsVcxiVkHxPITZDqQPF7HaMIaVnCT4M=";
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
