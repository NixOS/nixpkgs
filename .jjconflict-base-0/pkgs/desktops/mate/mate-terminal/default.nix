{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  mate-desktop,
  dconf,
  vte,
  pcre2,
  wrapGAppsHook3,
  mateUpdateScript,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "mate-terminal";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "8TXrGp4q4ieY7LLcGRT9tM/XdOa7ZcAVK+N8xslGnpI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    libxml2 # xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    mate-desktop
    pcre2
    vte
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  passthru.tests.test = nixosTests.terminal-emulators.mate-terminal;

  meta = with lib; {
    description = "MATE desktop terminal emulator";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
