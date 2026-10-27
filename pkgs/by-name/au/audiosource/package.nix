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
  version = "1.5";

  src = fetchFromGitHub {
    owner = "gdzx";
    repo = "audiosource";
    tag = "v${finalAttrs.version}";
    hash = "sha256-npN7V1svKaxCfsZBvmfm7T/UJsAQ4hQM3RN+tpK5cms=";
  };

  patches = [
    # Removes build-related logic from the script that is unused in the package
    ./unused-logic-removal.patch
    # Fixes a small bug with adb args on new Android versions
    ./adb-args-fix.patch
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
    hash = "sha256:cd48532829f41060d3c9909daa5563a669394eb9dd00baf303b6db1b5b2db1fa";
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
