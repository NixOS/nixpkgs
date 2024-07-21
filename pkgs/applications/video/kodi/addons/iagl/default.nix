{ lib, buildKodiAddon, fetchFromGitHub, dateutil, requests, routing, vfs-libarchive, archive_tool, youtube }:

buildKodiAddon rec {
  pname = "iagl";
  namespace = "plugin.program.iagl";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "zach-morris";
    repo = "plugin.program.iagl";
    rev = version;
    sha256 = "sha256-b8nO3D/xTnj/5UDshGlIJdiHd75VhIlkrGUi0vkZqG4=";
  };

  propagatedBuildInputs = [
    dateutil
    requests
    routing
    vfs-libarchive
    archive_tool
    youtube
  ];

  meta = with lib; {
    homepage = "https://github.com/zach-morris/plugin.program.iagl";
    description = "Launch Games from the Internet using Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
