{ lib, buildGoModule, fetchFromGitHub, yt-dlp, ffmpeg, mpv }:

buildGoModule rec {
  pname = "invidtui";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "invidtui";
    rev = "refs/tags/v${version}";
    hash = "sha256-m2ygORf6GIJZXYYJKy6i12wDEkxQywtYdCutHeiyNYY=";
  };

  vendorHash = "sha256-HQ6JHXiqawDwSV48/Czbao4opnuz1LqIBdcObrkCfNs=";

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
