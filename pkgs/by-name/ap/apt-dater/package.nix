{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  xxd,
  glib,
  libxml2,
  ncurses,
  popt,
  libxslt,
  screen,
}:

stdenv.mkDerivation {
  pname = "apt-dater";
  version = "1.0.4-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "DE-IBH";
    repo = "apt-dater";
    rev = "113ea9b72d318f316ea7cac8ddad5be004787a22";
    hash = "sha256-/Ufa/pEbqD25kp+k0zm9MuLS1zG+xWqhpBkL7ng2+Bo=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    xxd
  ];

  buildInputs = [
    libxml2
    ncurses
    glib
    popt
    screen
  ];

  configureFlags = [ "--disable-history" ];

  prePatch = ''
    substituteInPlace etc/Makefile.am \
      --replace-fail 02770 0770 \
      --replace-fail '../../../$(pkglibdir)' '$(pkglibdir)'
  '';

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "/usr/bin/screen" "${screen}/bin/screen" \
      --replace-fail "/usr/bin/xsltproc" "${libxslt}/bin/xsltproc" \
      --replace-fail "man/Makefile" "" # Need /usr/share/xml/docbook/stylesheet/nwalsh can't find in nixpkgs
    substituteInPlace Makefile.am \
      --replace-fail "man" ""
    substituteInPlace build/screen_sockpath \
      --replace-fail "/usr/bin/screen" "${screen}/bin/screen"
  '';

  postInstall = ''
    substituteInPlace $out/bin/adsh \
      --replace-fail "apt-dater" "$out/bin/apt-dater"
  '';

  doCheck = true;

  meta = {
    homepage = "https://github.com/DE-IBH/apt-dater";
    description = "Terminal-based remote package update manager";
    longDescription = ''
      Provides an ncurses frontend for managing package updates on a large
      number of remote hosts using SSH. It supports Debian-based managed hosts
      as well as rug (e.g. openSUSE) and yum (e.g. CentOS) based systems.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "apt-dater";
    maintainers = with lib.maintainers; [ c0bw3b ];
  };
}
