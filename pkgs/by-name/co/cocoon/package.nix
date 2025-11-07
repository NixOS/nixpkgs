{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cocoon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = finalAttrs.version;
    hash = "sha256-2zvbPhvYoKlQTZDjpo6LRr9DLKzSmcH0qnU1oJ+7k04=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-5WnME+AVrXfvHX2yPbFoL6QgZoCMAJmBj47OM7miOfc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ATProtocol Personal Data Server written in Go with a SQLite block and blob store";
    changelog = "https://github.com/haileyok/cocoon/releases/${finalAttrs.version}";
    homepage = "https://github.com/haileyok/cocoon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cocoon";
  };
})
