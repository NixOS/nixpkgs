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
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "apt-dater";
  version = "1.0.4-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "DE-IBH";
    repo = "apt-dater";
    rev = "eb3df6923262051082df2e9377516553da9ba508";
    hash = "sha256-I5TQ6sPIWD7jllelkvYjLa/7FI2IpWsGRS4FsxXQKGs=";
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

  # Use unstable to pull in gcc-15 fixes:
  #   https://github.com/DE-IBH/apt-dater/pull/187
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

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
