{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  udev,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "particle-cli";
  version = "3.36.1";

  src = fetchFromGitHub {
    owner = "particle-iot";
    repo = "particle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7u0RXoUBu/aJSBVSdmheIPvQ6b6Vji2KZ2t3sNhh3kY=";
  };

  npmDepsHash = "sha256-0yLu3iyHQwWId+EAXu4dlCNHvuFZeEts2r5Y+FpHPQI=";

  buildInputs = [
    udev
  ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

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
