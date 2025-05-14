{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  inputstream-adaptive,
  inputstreamhelper,
  routing,
}:

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
    # Needed for content decryption with Widevine.
    inputstream-adaptive
    inputstreamhelper
    routing
  ];

  meta = with lib; {
    homepage = "https://github.com/s0faking/plugin.video.orftvthek";
    description = "Addon for accessing the Austrian ORF ON streaming service";
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
  };
}
