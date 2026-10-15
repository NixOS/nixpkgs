{
  lib,
  stdenv,
  slop,
  ffmpeg,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "capture-unstable";
  version = "2019-03-10";

  src = fetchFromGitHub {
    owner = "buhman";
    repo = "capture";
    rev = "80dd9e7195aad5c132badef610f19509f3935b24";
    hash = "sha256-pg00lwwnjaQpz2lEW9Qsh3mzTrrR7dcFY8fbvCt53n8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 src/capture.sh $out/bin/capture

    patchShebangs $out/bin/capture
    wrapProgram $out/bin/capture \
      --prefix PATH : '${
        lib.makeBinPath [
          slop
          ffmpeg
        ]
      }'
  '';

  meta = {
    description = "No bullshit screen capture tool";
    homepage = "https://github.com/buhman/capture";
    maintainers = [ lib.maintainers.ar1a ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "capture";
  };
}
