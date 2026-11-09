{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gut";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = finalAttrs.version;
    hash = "sha256-h2lrmFfWENPD8i5kyDDtmN3hwliLPvVePhFdMfq46z8=";
  };

  vendorHash = "sha256-yO1+lNKVsPipyTBVKItmOKClMBdHphReSVP8KnQITJM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/julien040/gut/src/telemetry.gutVersion=${finalAttrs.version}"
  ];

  # Depends on `/home` existing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative git CLI";
    homepage = "https://gut-cli.dev";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gut";
  };
})
