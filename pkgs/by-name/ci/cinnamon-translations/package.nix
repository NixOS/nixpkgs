{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-translations";
    tag = version;
    hash = "sha256-6y1zHKO/qpkAL5fs6QUjNJki16X+bxW/175Sz1PUPQw=";
  };

  nativeBuildInputs = [
    gettext
  ];

  installPhase = ''
    mv usr $out # files get installed like so: msgfmt -o usr/share/locale/$lang/LC_MESSAGES/$dir.mo $file
  '';

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "Translations files for the Cinnamon desktop";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
