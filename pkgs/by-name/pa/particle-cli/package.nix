{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  udev,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "particle-cli";
  version = "3.35.11";

  src = fetchFromGitHub {
    owner = "particle-iot";
    repo = "particle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LqQAdyaNSyWDPZEZWnUT1NLbmRkuBVn4yUXgBlU5EUI=";
  };

  npmDepsHash = "sha256-CpDZrnOZFD42jIoyGCWiYoQgA2Bn2iwaOrSx0SdihTk=";

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
