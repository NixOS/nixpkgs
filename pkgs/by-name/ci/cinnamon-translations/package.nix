{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
  version = "6.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-translations";
    tag = version;
    hash = "sha256-By09Y4iHZz3XR7tRd5MyXK5BKOr01yJzTTLQHEZ00q0=";
  };

  nativeBuildInputs = [
    gettext
  ];

  installPhase = ''
    mv usr $out # files get installed like so: msgfmt -o usr/share/locale/$lang/LC_MESSAGES/$dir.mo $file
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "Translations files for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
