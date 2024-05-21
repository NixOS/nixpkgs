{ lib, buildGoModule, fetchFromGitHub, yt-dlp, ffmpeg, mpv }:

buildGoModule rec {
  pname = "invidtui";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "invidtui";
    rev = "refs/tags/v${version}";
    hash = "sha256-ErdoAHXdptUCZ2aW4XT1Hul/OBfnK6dfncgQ8JRFHxg=";
  };

  vendorHash = "sha256-C7O2GJuEdO8geRPfHx1Sq6ZveDE/u65JBx/Egh3cnK4=";

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
