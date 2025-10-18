{
  name,
  buildGo124Module,
  lib,
  stdenv,
  fetchFromGitHub,
  navidrome,
}:

# Builds plugins from the navidrome example folder
buildGo124Module rec {
  pname = name;
  inherit (navidrome) src version vendorHash;

  # doCheck = false;

  selfContainedBuild = true;

  buildPhase = ''
    runHook preBuild

    GOOS=wasip1 GOARCH=wasm go build -buildmode=c-shared -o plugin.wasm ./plugins/examples/${pname}/...

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    DEST=$out/share/plugins/${pname}
    install -m 755 -Dt $out/share/${pname} plugin.wasm plugins/examples/${pname}/manifest.json

    runHook postInstall
  '';
}
