{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pretender";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "pretender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NwGjW0WvMuoG4NxBL3ygGbZF5b8dLXJPbYMadLodR8s=";
  };

  vendorHash = "sha256-pzyattaJQIzEgCheYBx6qJ95br6ApEk9RfBfAqrPkjI=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for handling machine-in-the-middle tasks";
    homepage = "https://github.com/RedTeamPentesting/pretender";
    changelog = "https://github.com/RedTeamPentesting/pretender/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pretender";
  };
})
