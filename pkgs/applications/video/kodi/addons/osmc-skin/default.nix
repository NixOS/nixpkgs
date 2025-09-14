{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:
buildKodiAddon rec {
  pname = "osmc-skin";
  namespace = "skin.osmc";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "osmc";
    repo = namespace;
    rev = "v20.1.0-August-update";
    sha256 = "E/+gC7NlVRMaymeYMBO39/+rs0blDjr2zIROr24ekzQ=";
  };

  meta = {
    homepage = "https://github.com/osmc/skin.osmc";
    description = "Default skin for OSMC";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.cc-by-nc-sa-30;

    broken = true; # no release for kodi 21
  };
}
