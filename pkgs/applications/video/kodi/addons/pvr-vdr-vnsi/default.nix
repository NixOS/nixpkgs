{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libGL,
}:
buildKodiBinaryAddon rec {
  pname = "pvr-vdr-vnsi";
  namespace = "pvr.vdr.vnsi";
  version = "21.1.2";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.vdr.vnsi";
    rev = "${version}-${rel}";
    sha256 = "sha256-o7WVO/TvSK6bZEnUeNQhapXOVQbDlpJDObC93/9XpJo=";
  };

  extraBuildInputs = [ libGL ];

  meta = {
    homepage = "https://github.com/kodi-pvr/pvr.vdr.vnsi";
    description = "Kodi's VDR VNSI PVR client addon";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = lib.teams.kodi.members;
  };
}
