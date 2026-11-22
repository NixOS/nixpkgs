{
  lib,
  stdenvNoCC,
  fetchFromCodeberg,
  coreutils,
  ffmpeg,
  flac,
  installShellFiles,
  lame,
  opus-tools,
  perl,
  vorbis-tools,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "acxi";
  version = "3.6.03";

  src = fetchFromCodeberg {
    owner = "smxi";
    repo = "acxi";
    tag = finalAttrs.version;
    hash = "sha256-sdljl4nSNfGx8WB1S+f7kXx+KGijUWo+UzD9J+B/hTY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    perl
  ];

  installPhase = ''
    runHook preInstall

    installBin acxi
    installManPage acxi.1
    install -Dm644 acxi.conf $out/share/doc/acxi/acxi.conf.example
    substituteInPlace $out/bin/acxi \
      --replace-fail /usr/bin/flac ${lib.getExe' flac "flac"} \
      --replace-fail /usr/bin/ffmpeg ${lib.getExe' ffmpeg "ffmpeg"} \
      --replace-fail /usr/bin/ffprobe ${lib.getExe' ffmpeg "ffprobe"} \
      --replace-fail /usr/bin/lame ${lib.getExe' lame "lame"} \
      --replace-fail /usr/bin/oggenc ${lib.getExe' vorbis-tools "oggenc"} \
      --replace-fail /usr/bin/opusenc ${lib.getExe' opus-tools "opusenc"} \
      --replace-fail /usr/bin/md5sum ${lib.getExe' coreutils "md5sum"} \
      --replace-fail /usr/bin/metaflac ${lib.getExe' flac "metaflac"} \
      --replace-fail 'my $ALLOW_UPDATES = 1;' 'my $ALLOW_UPDATES = 0;'

    runHook postInstall
  '';

  meta = {
    homepage = "https://smxi.org/";
    changelog = "https://smxi.org/docs/acxi-changelog.htm";
    description = "Audio conversion tool that helps sync lossless to lossy formats";
    license = lib.licenses.gpl3Plus;
    mainProgram = "acxi";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
