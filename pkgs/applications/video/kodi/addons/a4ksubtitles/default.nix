{ lib, buildKodiAddon, fetchFromGitHub, requests, vfs-libarchive  }:

buildKodiAddon rec {
  pname = "a4ksubtitles";
  namespace = "service.subtitles.a4ksubtitles";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "a4k-openproject";
    repo = "a4kSubtitles";
    rev = "${namespace}/${namespace}-${version}";
    sha256 = "0fg5mcvxdc3hqybp1spy7d1nnqirwhcvrblbwksikym9m3qgw2m5";
  };

  propagatedBuildInputs = [
    requests
    vfs-libarchive
  ];

  meta = with lib; {
    homepage = "https://a4k-openproject.github.io/a4kSubtitles/";
    description = "Multi-Source Subtitles Addon";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
