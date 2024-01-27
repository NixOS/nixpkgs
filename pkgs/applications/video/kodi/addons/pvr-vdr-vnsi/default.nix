{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libGL }:
buildKodiBinaryAddon rec {
  pname = "pvr-vdr-vnsi";
  namespace = "pvr.vdr.vnsi";
  version = "20.4.1";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.vdr.vnsi";
    rev = "${version}-${rel}";
    sha256 = "sha256-QooWK+LwlN5RAISjAQ2YiyDAjQQMzod8fFXpI0ll+hc=";
  };

  extraBuildInputs = [ libGL ];

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.vdr.vnsi";
    description = "Kodi's VDR VNSI PVR client addon";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
