{ lib, buildKodiAddon, fetchFromGitHub, future, kodi-six, simplejson, inputstreamhelper }:

buildKodiAddon rec {
  pname = "orftvthek";
  namespace = "plugin.video.orftvthek";
  version = "0.12.12";

  src = fetchFromGitHub {
    owner = "s0faking";
    repo = namespace;
    rev = version;
    sha256 = "sha256-4VLr4DFxioCrlq5JtiPyd7E4a+++cWgxCnRb3KPppWE=";
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
