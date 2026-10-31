{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  testers,

  buildNpmPackage,
  typescript,
  nodejs,
}:
buildNpmPackage (finalAttrs: {
  pname = "rp2040js";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "wokwi";
    repo = "rp2040js";
    tag = "v${finalAttrs.version}";
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

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };
  };

  meta = {
    description = "Raspberry Pi Pico (RP2040) Emulator";
    homepage = "https://github.com/wokwi/rp2040js";
    changelog = "https://github.com/wokwi/rp2040js/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.baileylu
    ];
    mainProgram = "rp2040js";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
})
