{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon-translations";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-translations";
    tag = finalAttrs.version;
    hash = "sha256-i5e3OddOUrsvuSlLO4BSLjvQ4v95lfzb0Ncnmfzd7Cw=";
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
})
