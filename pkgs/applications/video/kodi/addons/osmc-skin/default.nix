{ lib, buildKodiAddon, fetchFromGitHub }:
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

  meta = with lib; {
    homepage = "https://github.com/osmc/skin.osmc";
    description = "The default skin for OSMC";
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    license = licenses.cc-by-nc-sa-30;
  };
}
