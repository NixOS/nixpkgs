{ lib, buildKodiAddon, fetchFromGitHub, requests, vfs-libarchive  }:

buildKodiAddon rec {
  pname = "a4ksubtitles";
  namespace = "service.subtitles.a4ksubtitles";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "a4k-openproject";
    repo = "a4kSubtitles";
    rev = "${namespace}/${namespace}-${version}";
    sha256 = "sha256-t6oclFAOsUC+hFtw6wjRh1zl2vQfc7RKblVJpBPfE9w=";
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
