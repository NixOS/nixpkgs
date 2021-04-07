{ lib, buildKodiAddon, fetchFromGitHub, requests, vfs-libarchive  }:

buildKodiAddon rec {
  pname = "a4ksubtitles";
  namespace = "service.subtitles.a4ksubtitles";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "a4k-openproject";
    repo = "a4kSubtitles";
    rev = "${namespace}/${namespace}-${version}";
    sha256 = "0hxvxkbihfyvixmlxf5n4ccn70w0244hhw3hr44rqvx00a0bg1lh";
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
