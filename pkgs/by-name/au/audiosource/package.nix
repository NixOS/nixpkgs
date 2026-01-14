{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  python3,
  android-tools,
  pulseaudio,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audiosource";
  version = "1.4";

  passthru.apk = fetchurl {
    url = "https://github.com/gdzx/audiosource/releases/download/v${finalAttrs.version}/audiosource.apk";
    hash = "sha256-vDIF+NZ3JgTT67Dem4qeajWsA5m/MFt2nRDpWUqC9aU=";
  };

  src = fetchFromGitHub {
    owner = "gdzx";
    repo = "audiosource";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SlX8gjs7X5jfoeU6pyk4n8f6oMJgneGVt0pmFs48+mQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./audiosource.patch ];

  postPatch = ''
    substituteInPlace audiosource \
      --replace-fail "@apkPath@" "$out/share/audiosource/audiosource.apk"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/audiosource
    cp ${finalAttrs.passthru.apk} $out/share/audiosource/audiosource.apk
    cp audiosource $out/bin/audiosource
    chmod +x $out/bin/audiosource

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/audiosource \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          android-tools
          pulseaudio
          coreutils
        ]
      }
  '';

  meta = {
    description = "Use an Android device as a USB microphone";
    homepage = "https://github.com/gdzx/audiosource";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ikci ];
    mainProgram = "audiosource";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
