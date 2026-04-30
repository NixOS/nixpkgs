{
  bc,
  coreutils,
  fetchFromGitHub,
  ffmpeg,
  findutils,
  gawk,
  gnugrep,
  gnused,
  jq,
  lame,
  lib,
  makeWrapper,
  mediainfo,
  mp4v2,
  ncurses,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aaxtomp3";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "krumpetpirate";
    repo = "aaxtomp3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7a9ZVvobWH/gPxa3cFiPL+vlu8h1Dxtcq0trm3HzlQg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace AAXtoMP3 \
      --replace-fail 'AAXtoMP3' 'aaxtomp3'
    substituteInPlace interactiveAAXtoMP3 \
      --replace-fail 'AAXtoMP3' 'aaxtomp3' \
      --replace-fail 'call="./aaxtomp3"' 'call="${placeholder "out"}/bin/aaxtomp3"'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 AAXtoMP3 $out/bin/aaxtomp3
    install -Dm 755 interactiveAAXtoMP3 $out/bin/interactiveaaxtomp3

    runHook postInstall
  '';

  postFixup =
    let
      runtimePath = lib.makeBinPath [
        bc
        coreutils
        ffmpeg
        findutils
        gawk
        gnugrep
        gnused
        jq
        lame
        mediainfo
        mp4v2
        ncurses
      ];
    in
    ''
      wrapProgram $out/bin/aaxtomp3 --prefix PATH : ${runtimePath}
      wrapProgram $out/bin/interactiveaaxtomp3 --prefix PATH : ${runtimePath}
    '';

  meta = {
    description = "Convert Audible's .aax filetype to MP3, FLAC, M4A, or OPUS";
    homepage = "https://krumpetpirate.github.io/AAXtoMP3";
    license = lib.licenses.wtfpl;
    maintainers = [ ];
  };
})
