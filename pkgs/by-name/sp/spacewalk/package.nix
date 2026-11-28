{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spacewalk";
  version = "0.1.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/InsaneArts/Spacewalk/releases/download/v${finalAttrs.version}/Spacewalk-v${finalAttrs.version}.zip";
    hash = "sha256-U6LJJ1dv4OR6HDJCjENxcXRwacKxDh3+JUC2h401vuI=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications" "$out/bin"
    cp -R Spacewalk.app "$out/Applications/"
    ln -s ../Applications/Spacewalk.app/Contents/MacOS/spacewalk-cli "$out/bin/spacewalk"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/InsaneArts/Spacewalk/releases/tag/v${finalAttrs.version}";
    description = "Animated switching between macOS Spaces";
    homepage = "https://github.com/InsaneArts/Spacewalk";
    license = lib.licenses.mit;
    longDescription = ''
      Spacewalk provides animated transitions when switching between macOS Spaces.
      It requires macOS 26.6 or newer on Apple Silicon.
    '';
    mainProgram = "spacewalk";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
