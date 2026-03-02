{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  installShellFiles,
  python3,
  android-tools,
  pulseaudio,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audiosource";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "gdzx";
    repo = "audiosource";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SlX8gjs7X5jfoeU6pyk4n8f6oMJgneGVt0pmFs48+mQ=";
  };

  patches = [
    # Removes build-related logic from the script that is unused in the package and fixes a small bug with adb args on new Android versions
    ./unused-logic-removal-and-args-fix.patch
  ];

  postPatch = ''
    substituteInPlace audiosource \
      --replace-fail "@apkPath@" "$out/share/audiosource/audiosource.apk"
  '';

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/audiosource
    cp ${finalAttrs.passthru.apk} $out/share/audiosource/audiosource.apk

    installBin audiosource

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

  passthru.apk = fetchurl {
    url = "https://github.com/gdzx/audiosource/releases/download/v${finalAttrs.version}/audiosource.apk";
    hash = "sha256-vDIF+NZ3JgTT67Dem4qeajWsA5m/MFt2nRDpWUqC9aU=";
  };

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
