{
  lib,
  buildGoModule,
  fetchFromGitHub,
  yt-dlp,
  ffmpeg,
  mpv,
}:

buildGoModule (finalAttrs: {
  pname = "invidtui";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "invidtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C465lzbZIh8LYDUHNa5u66nFteFsKAffilvy1Danfpg=";
  };

  vendorHash = "sha256-C7O2GJuEdO8geRPfHx1Sq6ZveDE/u65JBx/Egh3cnK4=";

  doCheck = true;

  postPatch = ''
    substituteInPlace cmd/flags.go \
      --replace "\"ffmpeg\"" "\"${lib.getBin ffmpeg}/bin/ffmpeg\"" \
      --replace "\"mpv\"" "\"${lib.getBin mpv}/bin/mpv\"" \
      --replace "\"yt-dlp\"" "\"${lib.getBin yt-dlp}/bin/yt-dlp\""
  '';

  meta = {
    homepage = "https://darkhz.github.io/invidtui/";
    description = "Invidious TUI client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rettetdemdativ ];
    mainProgram = "invidtui";
  };
})
