{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cgtcalc";
  version = "0.1.0-unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "mattjgalloway";
    repo = "cgtcalc";
    rev = "29adf5bf39f870d4098bc828f356864190e41969";
    hash = "sha256-koyvaeJSbhql7ERuJY6EBRTtT3MCYS6Sp+XANJmvMms=";
  };
  nativeBuildInputs = [
    swift
    swiftpm
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) src;
    hash = "sha256-FBoYVbVMdSZ2q89h7Mcn6vlPNScTJqzoSJKS6wgUGwY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $(swiftpmBinPath)/cgtcalc $out/bin/
    runHook postInstall
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "UK capital gains tax calculator written in Swift";
    homepage = "https://github.com/mattjgalloway/cgtcalc";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "cgtcalc";
    platforms = lib.platforms.all;
  };
})
