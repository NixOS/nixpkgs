{ coreutils
, fetchFromGitHub
, ffmpeg
, findutils
, gnugrep
, gnused
, jq
, lame
, lib
, makeWrapper
, mediainfo
, mp4v2
, stdenv
}:
let
  runtimeInputs = [
    coreutils
    ffmpeg
    findutils
    gnugrep
    gnused
    jq
    lame
    mediainfo
    mp4v2
  ];
in
stdenv.mkDerivation rec {
  pname = "aaxtomp3";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "krumpetpirate";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7a9ZVvobWH/gPxa3cFiPL+vlu8h1Dxtcq0trm3HzlQg=";
  };

  dontBuild = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 AAXtoMP3 $out/bin/aaxtomp3
    wrapProgram $out/bin/aaxtomp3 --prefix PATH : ${lib.makeBinPath runtimeInputs}
    install -Dm755 interactiveAAXtoMP3 $out/bin/interactiveaaxtomp3
    wrapProgram $out/bin/interactiveaaxtomp3 --prefix PATH : ${lib.makeBinPath runtimeInputs}
  '';

  meta = with lib; {
    description = "Convert Audible's .aax filetype to MP3, FLAC, M4A, or OPUS";
    homepage = "https://krumpetpirate.github.io/AAXtoMP3";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ urandom ];
  };
}
