{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  testers,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  platform = selectSystem {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-aarch64";
    "x86_64-darwin" = "mac-x64";
    "aarch64-darwin" = "mac-aarch64";
  };

  hash = selectSystem {
    "x86_64-linux" = "sha256-EweSqy30NJuxvlJup78O+e+JOkzvUdb6DshqAy1j9jE=";
    "aarch64-linux" = "sha256-MhHEYHBctaDH9JVkN/guDCG1if9Bip1aP3n+JkvHCvA=";
  };
in

stdenv.mkDerivation (finalAttrs: rec {
  pname = "kotlin-lsp";
  version = "261.13587.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-lsp-${version}-${platform}.zip";
    inherit hash;
    stripRoot = false; # fix for "error: zip file must contain a single file or directory"
  };

  patches = [
    ./no-chmod.diff
  ];

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    zlib
    stdenv.cc.cc.lib # for libgcc_s
  ];

  dontBuild = true;

  installPhase = ''
    chmod +x ./kotlin-lsp.sh
    chmod +x ./jre/bin/java

    # kotlin-lsp is headless so we can reduce the auto-patchelf dependencies
    rm ./jre/lib/lib{awt_{wl,x}awt,jawt,fontmanager,jsound,{wl,}splashscreen}*

    # retain original directory structure to reduce necessary patching
    mkdir -p $out/opt/kotlin-lsp $out/bin
    cp -r ./* $out/opt/kotlin-lsp
    ln -s "$out/opt/kotlin-lsp/kotlin-lsp.sh" "$out/bin/kotlin-lsp"
  '';

  passthru.tests.help = testers.testVersion {
    # not checking the version but this checks the JVM classpath and statically (i.e. at import time) loaded native libraries
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} --help";
    version = "Usage: ${finalAttrs.meta.mainProgram}";
  };

  meta = {
    description = "Official Kotlin language server based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin.";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    changelog = "https://github.com/Kotlin/kotlin-lsp/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ axka ];
    platforms = lib.platforms.linux; # macOS people, feel free to expand this!
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "kotlin-lsp";
  };
})
