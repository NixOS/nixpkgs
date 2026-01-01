{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
<<<<<<< HEAD
  version = "6.6.1";
=======
  version = "6.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-translations";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-6y1zHKO/qpkAL5fs6QUjNJki16X+bxW/175Sz1PUPQw=";
=======
    hash = "sha256-By09Y4iHZz3XR7tRd5MyXK5BKOr01yJzTTLQHEZ00q0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    gettext
  ];

  installPhase = ''
    mv usr $out # files get installed like so: msgfmt -o usr/share/locale/$lang/LC_MESSAGES/$dir.mo $file
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "Translations files for the Cinnamon desktop";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "Translations files for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
