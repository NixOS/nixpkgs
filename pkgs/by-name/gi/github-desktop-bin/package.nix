{
  lib,
  stdenvNoCC,
  fetchurl,

  makeWrapper,
  unzip,

  github-desktop,
}:

let
  cpuName =
    {
      x86_64 = "x64";
      aarch64 = "arm64";
    }
    .${stdenvNoCC.hostPlatform.parsed.cpu.name};
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-desktop-bin";
  version = "3.5.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl finalAttrs.passthru.sources.${cpuName};

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/Applications
    unzip $src -d $out/Applications

    # since we inherit mainProgram from github-desktop, we need the
    # selfdirection here...
    makeWrapper \
      $out/Applications/GitHub\ Desktop.app/Contents/MacOS/GitHub\ Desktop \
      $out/bin/${finalAttrs.meta.mainProgram}
  '';

  passthru = {
    updateScript = ./update.sh;
    sources = lib.importJSON ./sources.json;
  };

  meta = github-desktop.meta // {
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
