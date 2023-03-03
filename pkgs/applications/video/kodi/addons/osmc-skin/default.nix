{ lib, buildKodiAddon, fetchFromGitHub }:
buildKodiAddon rec {
  pname = "osmc-skin";
  namespace = "skin.osmc";
  version = "18.0.0";

  src = fetchFromGitHub {
    owner = "osmc";
    repo = namespace;
    rev = "40a6c318641e2cbeac58fb0e7dde9c2beac737a0";
    sha256 = "1l7hyfj5zvjxjdm94y325bmy1naak455b9l8952sb0gllzrcwj6s";
  };

  meta = with lib; {
    homepage = "https://github.com/osmc/skin.osmc";
    description = "The default skin for OSMC";
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    license = licenses.cc-by-nc-sa-30;
  };
}
