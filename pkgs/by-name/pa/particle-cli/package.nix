{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  udev,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "particle-cli";
  version = "3.52.3";

  src = fetchFromGitHub {
    owner = "particle-iot";
    repo = "particle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aXFppjP2XPk1ABHaPUkAeYW0ZxeaUJKTzzHTX+fXe3o=";
  };

  npmDepsHash = "sha256-XPT94nGUMiUWw2Q8Dv727d7tWJx3eJZLYzra+KMXsMM=";

  buildInputs = [
    udev
  ];

  dontNpmBuild = true;
  dontNpmPrune = false;

  postInstall = ''
    install -D -t $out/etc/udev/rules.d \
      $out/lib/node_modules/particle-cli/assets/50-particle.rules
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command Line Interface for Particle Cloud and devices";
    homepage = "https://github.com/particle-iot/particle-cli";
    maintainers = with lib.maintainers; [ jess ];
    mainProgram = "particle";
    license = lib.licenses.asl20;
  };
})
