{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "docker-color-output";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "devemio";
    repo = "docker-color-output";
    # Warning: tag names are inconsistent: some have the 'v' prefix, some don't.
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rpym9YckgJ583zgPpC/mQW1IGgQUppemFhAecgy3M8A=";
  };

  postInstall = ''
    mv $out/bin/cli $out/bin/docker-color-output
  '';

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Add color to the Docker CLI";
    mainProgram = "docker-color-output";
    license = lib.licenses.mit;
    homepage = "https://github.com/devemio/docker-color-output";
    # Note that due to inconsistent tag names (see above comment),
    # we might want to check the URL before committing.
    changelog = "https://github.com/devemio/docker-color-output/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ sguimmara ];
  };
})
