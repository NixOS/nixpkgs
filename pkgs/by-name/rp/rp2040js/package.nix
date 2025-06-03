{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  testers,

  buildNpmPackage,
  typescript,
  nodejs,
  ...
}:
let
  version = "1.1.1";
in
buildNpmPackage (finalAttrs: {
  pname = "rp2040js";
  inherit version;

  src = fetchFromGitHub {
    owner = "wokwi";
    repo = "rp2040js";
    tag = "v${version}";
    hash = "sha256-yra47Rg4xMmRX598LX4SvVhuS/ox5gS+j2mBk7E2nIY=";
  };

  nativeBuildInputs = [
    typescript
    makeWrapper
  ];

  patches = [ ./tsc-build-demo.patch ];

  buildPhase = ''
    tsc
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/lib/rp2040js

    cp -R ./dist/. $out/lib/rp2040js/
    cp -R ./node_modules/ $out/lib/rp2040js/

    makeWrapper ${nodejs}/bin/node $out/bin/rp2040js \
      --add-flags "$out/lib/rp2040js/demo/emulator-run.js" \
      --prefix NODE_PATH : "$out/lib/rp2040js/"
  '';

  dontFixup = true;

  npmDepsHash = "sha256-sNMv/zoNwA+pIpDMNzCXcnLWEuBLgQrkdSeQjCELbqY=";

  meta = {
    description = "Raspberry Pi Pico (RP2040) Emulator";
    homepage = "https://github.com/wokwi/rp2040js";
    changelog = "https://github.com/wokwi/rp2040js/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.baileylu
    ];
    platforms = lib.platforms.all;
    mainProgram = "rp2040js";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "rp2040js";
      inherit version;
    };
  };
})
