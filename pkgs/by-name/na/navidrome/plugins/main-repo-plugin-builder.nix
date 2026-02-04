{
  name,
  vendorHash,
  buildGoModule,
  lib,
  stdenv,
  fetchFromGitHub,
  navidrome,
}:

# Builds plugins from the navidrome example folder
buildGoModule rec {
  pname = name;
  inherit (navidrome) version;

  inherit vendorHash;

  src = navidrome.src // {
    sourceRoot = "plugins/examples/${pname}";
  };

  env.CGO_ENABLED = "0";

  buildPhase = ''
    runHook preBuild

    GOOS=wasip1 \
    GOARCH=wasm \
    go build \
      -buildmode=c-shared \
      -o ../plugin.wasm .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    DEST=$out/share/plugins/${pname}
    install -m 755 -Dt $out/share/${pname} plugins/plugin.wasm plugins/examples/${pname}/manifest.json

    runHook postInstall
  '';
}
