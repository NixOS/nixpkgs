{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  udev,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "particle-cli";
  version = "3.45.0";

  src = fetchFromGitHub {
    owner = "particle-iot";
    repo = "particle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hq2flUBStEouVEhYI25fNFK9ohvHfk792vlPa7b3DRA=";
  };

  npmDepsHash = "sha256-rHT8ZLBe3uO1NxrbVBdrh0fn9gvBVq4XE8Gfhcshq/E=";

  buildInputs = [
    udev
  ];

  dontNpmBuild = true;
  dontNpmPrune = true;

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
