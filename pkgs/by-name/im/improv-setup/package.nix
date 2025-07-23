{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "improv-setup";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "git.clerie.de";
    owner = "clerie";
    repo = "improv-setup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3vF8StD2qk3S87Rw7hphmIW2udlFK9e4YQfHF12yFwI=";
  };

  cargoHash = "sha256-H2X1hpynOIZOHBx8nZz09Yr4zk/7Ikn6TNhx3cCmOuA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configure Wifi credentials on IOT devices using Improv serial protocol";
    homepage = "https://git.clerie.de/clerie/improv-setup/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fooker ];
  };
})
