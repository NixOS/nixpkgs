{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  libxml2,
  pciutils,
  pkg-config,
  gtk2,
  ddccontrol-db,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddccontrol";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    tag = finalAttrs.version;
    sha256 = "sha256-qyD6i44yH3EufIW+LA/LBMW20Tejb49zvsDfv6YFD6c=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    libxml2
    pciutils
    gtk2
    ddccontrol-db
  ];

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  prePatch = ''
    substituteInPlace configure.ac              \
      --replace                                 \
      "\$""{datadir}/ddccontrol-db"             \
      "${ddccontrol-db}/share/ddccontrol-db"

    substituteInPlace src/ddcpci/Makefile.am    \
       --replace "chmod 4711" "chmod 0711"
  '';

  preConfigure = ''
    intltoolize --force
  '';

  meta = {
    description = "Program used to control monitor parameters by software";
    homepage = "https://github.com/ddccontrol/ddccontrol";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pakhfn
      doronbehar
    ];
  };
})
