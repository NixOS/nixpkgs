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
  version = "20261015";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    tag = finalAttrs.version;
    sha256 = "sha256-yMHZOF7At/pizuL9MeOFqua3BINT9kH83Htbk99Wgcw=";
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
