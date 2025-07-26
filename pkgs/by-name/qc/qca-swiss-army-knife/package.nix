{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalPackage: {
  pname = "qca-swiss-army-knife";
  version = lib.substring 0 8 finalPackage.src.rev;
  src = fetchFromGitHub {
    owner = "qca";
    repo = "qca-swiss-army-knife";
    rev = "e53ea71655c9f8a23f4bed7731fca53f0e96cdbd";
    hash = "sha256-OtK17Wk+jKKBf1Me6pduiZUXxkK31kGva/Bf/shFU6Q=";
  };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tools/scripts/ath{10,11,12}k/* $out/bin/
    chmod +x $out/bin/*
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-branch=master"
    ];
  };

  meta = {
    description = "Firmware utilities for ath10k and later chipsets";
    homepage = "https://github.com/qca/qca-swiss-army-knife";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ numinit ];
    platforms = with lib.platforms; linux;
  };
})
