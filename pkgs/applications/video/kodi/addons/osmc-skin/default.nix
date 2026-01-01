{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:
buildKodiAddon rec {
  pname = "osmc-skin";
  namespace = "skin.osmc";
  version = "21.1.1";

  src = fetchFromGitHub {
    owner = "osmc";
    repo = namespace;
    tag = "v${version}-August-update";
    hash = "sha256-3BR6HfKefuyybDv9c/ZkkZMRDyWNZWpftulXyUAD9nY=";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/osmc/skin.osmc";
    description = "Default skin for OSMC";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.cc-by-nc-sa-30;
=======
  meta = with lib; {
    homepage = "https://github.com/osmc/skin.osmc";
    description = "Default skin for OSMC";
    platforms = platforms.all;
    maintainers = [ ];
    license = licenses.cc-by-nc-sa-30;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
