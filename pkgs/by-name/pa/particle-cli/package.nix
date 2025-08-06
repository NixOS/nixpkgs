{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  udev,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "particle-cli";
  version = "3.40.0";

  src = fetchFromGitHub {
    owner = "particle-iot";
    repo = "particle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qfwj0hs+4p00pALrIMAjHCM7Cdoj6+sxV/nMyI2rYNg=";
  };

  npmDepsHash = "sha256-o8G6+xYOg80vgjJ6Skm7ydysuH71uN9erj7Nd4QOB2I=";

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
