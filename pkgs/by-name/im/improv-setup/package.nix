{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "improv-setup";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "git.clerie.de";
    owner = "clerie";
    repo = "improv-setup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N/HMvyZfWuxzNg0IDvyNVJiNBh7gb+v38mjVYmt2vw4=";
  };

  cargoHash = "sha256-vv7i+RsOjYaVWLmyBcvYNdiKsPOP4GyKyWAYB718Liw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configure Wifi credentials on IOT devices using Improv serial protocol";
    homepage = "https://git.clerie.de/clerie/improv-setup/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fooker ];
  };
})
