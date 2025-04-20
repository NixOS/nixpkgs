{
  lib,
  stdenvNoCC,
  fetchzip,
  runCommand,
  cosmocc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmocc";
  version = "4.0.2";

  cosmopolitan-cosmocc = fetchzip {
    url = "https://github.com/jart/cosmopolitan/releases/download/${finalAttrs.version}/cosmocc-${finalAttrs.version}.zip";
    hash = "sha256-6KZv7KU2rJhwfc9k6z9I6ZdfIS1KqRFLZUo8YyuD7ZY=";
    stripRoot = false;
  };

  dontUnpack = true;
  dontConfigure = true;
  doCheck = false;
  dontFixup = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    ln -s ${finalAttrs.cosmopolitan-cosmocc} $out

    runHook postInstall
  '';

  passthru.tests.cc = runCommand "c-test" { } ''
    ${cosmocc}/bin/cosmocc ${./hello.c}
    ./a.out > $out
  '';

  meta = {
    description = "compilers for Cosmopolitan C/C++ programs";
    homepage = "https://github.com/jart/cosmopolitan";
    downloadPage = "https://cosmo.zip/pub/cosmocc";
    license = lib.licenses.isc;
    maintainers = lib.teams.cosmopolitan.members;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
