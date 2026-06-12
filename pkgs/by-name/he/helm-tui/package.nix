{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "helm-tui";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "pidanou";
    repo = "helm-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VKMDMZnbLsxhSy5YP5wfXdts+4SrZxyDUw0ii0dGe4Q=";
  };

  vendorHash = "sha256-2uQswNCcJ+jtxEy3Nk3VWENCPOaGK8rhvbH9bHQfClE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple terminal UI for Helm";
    homepage = "https://github.com/pidanou/helm-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "helm-tui";
  };
})
