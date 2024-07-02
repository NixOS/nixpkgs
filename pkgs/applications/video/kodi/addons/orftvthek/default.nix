{ lib, buildKodiAddon, fetchFromGitHub, future, kodi-six, simplejson, inputstreamhelper }:

buildKodiAddon rec {
  pname = "orftvthek";
  namespace = "plugin.video.orftvthek";
  version = "1.0.2+matrix.1";

  src = fetchFromGitHub {
    owner = "s0faking";
    repo = namespace;
    rev = version;
    sha256 = "sha256-bCVsR7lH0REJmG3OKU8mRRvw/PhSrLfhufmVBmw05+k=";
  };

  propagatedBuildInputs = [
    future
    kodi-six
    simplejson
    inputstreamhelper
  ];

  meta = with lib; {
    homepage = "https://github.com/s0faking/plugin.video.orftvthek";
    description = "Addon that gives you access to the ORF TVthek Video Platform";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
