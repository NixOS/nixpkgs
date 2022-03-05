{ lib, buildKodiAddon, fetchFromGitHub, future, kodi-six, simplejson, inputstreamhelper }:

buildKodiAddon rec {
  pname = "orftvthek";
  namespace = "plugin.video.orftvthek";
  version = "0.12.3+matrix.1";

  src = fetchFromGitHub {
    owner = "s0faking";
    repo = namespace;
    rev = version;
    sha256 = "sha256-GB9VkC9Vbi7TJXl/vF3ViF/tAcHGH0KxYQ0zkfMLZCY=";
  };

  propagatedBuildInputs = [
    future
    kodi-six
    simplejson
    inputstreamhelper
  ];

  meta = with lib; {
    homepage = "https://github.com/s0faking/plugin.video.orftvthek";
    description = "An addon that gives you access to the ORF TVthek Video Platform";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
