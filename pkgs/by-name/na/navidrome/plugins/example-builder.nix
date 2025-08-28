{
  name,
}:
{
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

  doCheck = false;

  buildPhase = ''
    GOOS=wasip1 GOARCH=wasm go build -buildmode=c-shared -o plugin.wasm ./plugins/examples/${pname}/...
  '';

  installPhase = ''
    DEST=$out/share/plugins/${pname}
    install -m 755 -Dt $out/share/${pname} plugin.wasm plugins/examples/${pname}/manifest.json
  '';
}
