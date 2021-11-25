{ lib, buildKodiAddon, fetchFromGitHub, fetchzip, dateutil, requests, routing, vfs-libarchive, archive_tool, youtube }:

buildKodiAddon rec {
  pname = "iagl";
  namespace = "plugin.program.iagl";
  version = "1101521-2";

  src = fetchFromGitHub {
    owner = "zach-morris";
    repo = "plugin.program.iagl";
    rev = "30e82eec1a909b31767f0e298cf77fc970b256d3";
    sha256 = "11y05i5f7lzik23w2kr52jdgr8db3gin8i683sy1hzxlmplk4699";
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
