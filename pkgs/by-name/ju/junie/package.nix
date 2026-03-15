{
  lib,
  fetchurl,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  stdenv,
  zlib,
  pcsclite,
  libx11,
  libxrender,
  libxtst,
  libxi,
  harfbuzz,
  freetype,
  libjpeg8,
  lcms2,
  giflib,
  alsa-lib,
  versionCheckHook,
}:

let
  source = lib.importJSON ./source.json;
  platform = stdenv.hostPlatform.system;
  throwSystem = throw "Unsupported system: ${platform}";
  platformInfo = source.platforms.${platform} or throwSystem;
in
stdenv.mkDerivation {
  pname = "junie";
  inherit (source) version;

  src = fetchurl {
    url = "https://github.com/JetBrains/junie/releases/download/${source.version}/junie-release-${source.version}-${
      {
        aarch64-linux = "linux-aarch64";
        x86_64-linux = "linux-amd64";
        aarch64-darwin = "macos-aarch64";
      }
      .${platform} or throwSystem
    }.zip";
    inherit (platformInfo) hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc
    zlib
    pcsclite
    libx11
    libxrender
    libxtst
    libxi
    harfbuzz
    freetype
    libjpeg8
    lcms2
    giflib
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/libexec
    cp -r junie-app $out/libexec/junie-app

    makeWrapper $out/libexec/junie-app/bin/junie $out/bin/junie
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r Applications/junie.app $out/Applications/junie.app

    makeWrapper $out/Applications/junie.app/Contents/MacOS/junie $out/bin/junie
  ''
  + ''

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "JUNIE_HOME" ];
  preVersionCheck = ''
    export JUNIE_HOME="$(mktemp -d)/.junie"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    mainProgram = "junie";
    description = "AI coding assistant CLI by JetBrains";
    homepage = "https://www.jetbrains.com/junie/";
    downloadPage = "https://github.com/JetBrains/junie/releases";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames source.platforms;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
}
