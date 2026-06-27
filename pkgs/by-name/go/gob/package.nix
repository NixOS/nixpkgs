{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gob";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "juanibiapina";
    repo = "gob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YJdYfaa8AySfhTowVdMd4fWJa4oSxwtxJwoOX69tUkk=";
  };

  vendorHash = "sha256-5eqJDZ5EwLfcfIMe1lD5+0bkMG3OKy4ZBmqlsHdz27E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juanibiapina/gob/internal/version.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Process manager for AI agents and humans";
    homepage = "https://github.com/juanibiapina/gob";
    changelog = "https://github.com/juanibiapina/gob/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    mainProgram = "gob";
  };
})
