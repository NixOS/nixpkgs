{ lib, buildGoModule, fetchFromGitHub, yt-dlp, ffmpeg, mpv }:

buildGoModule rec {
  pname = "invidtui";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "invidtui";
    rev = "refs/tags/v${version}";
    hash = "sha256-bzstO6xaVdu7u1vBgwUjnJ9CEep0UHT73FbybBRd8y8=";
  };

  vendorHash = "sha256-F0Iyy8H6ZRYiAlMdYGQS2p2hFN9ICmfTiRP/F9kpW7c=";

  doCheck = true;

  postPatch = ''
        substituteInPlace cmd/flags.go \
          --replace "\"ffmpeg\"" "\"${lib.getBin ffmpeg}/bin/ffmpeg\"" \
          --replace "\"mpv\"" "\"${lib.getBin mpv}/bin/mpv\"" \
          --replace "\"yt-dlp\"" "\"${lib.getBin yt-dlp}/bin/yt-dlp\""
  '';

  meta = with lib; {
    homepage = "https://darkhz.github.io/invidtui/";
    description = "An invidious TUI client";
    license = licenses.mit;
    maintainers = with maintainers; [ rettetdemdativ ];
    mainProgram = "invidtui";
  };
}
