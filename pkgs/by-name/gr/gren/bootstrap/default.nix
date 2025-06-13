{
  lib,
  stdenv,
  fetchurl,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  runCommand,
  makeWrapper,
}:

let

  version = "0.4.5";
  fetchBootstrapBin =
    { bin, hash }:
    fetchurl {
      url = "https://github.com/gren-lang/compiler/releases/download/${version}/${bin}";
      inherit hash;
    };

  bootstrapBinaries = {
    "x86_64-linux" = fetchBootstrapBin {
      bin = "gren_linux";
      hash = "sha256-et5EKG/Z/kiuTKfIyyTf5lKgU6SAPy47itUOn657W+s=";
    };
    # TODO: x86_64-darwin, aarch64-darwin
  };

  rawBinary = bootstrapBinaries.${stdenv.hostPlatform.system};

  backend = runCommand "gren-backend" { meta.mainProgram = "gren"; } ''
    install -Dm755 ${rawBinary} $out/bin/gren
  '';
in
stdenv.mkDerivation rec {
  pname = "gren-bootstrap-npm";
  inherit version;

  src = ./src;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-HxMqoN1NtCCplxDaBP1uWM4P364K0/MRSo6zAuSZLIE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    makeWrapper
  ];

  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/share/gren-bootstrap
    cp -r node_modules $out/share/gren-bootstrap
    makeWrapper $out/share/gren-bootstrap/node_modules/.bin/gren $out/bin/gren \
      --set GREN_BIN ${lib.getExe backend}
  '';

  passthru = {
    inherit backend;
  };
}
