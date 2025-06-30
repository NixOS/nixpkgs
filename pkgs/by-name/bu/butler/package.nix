{
  buildGoModule,
  brotli,
  lib,
  fetchFromGitHub,
}:

# update instructions:
# - Check if butler version bug was fixed https://github.com/itchio/butler/issues/266
# - if it's fixed, remove patch.
# - if it was not fixed, follow steps below to regenerate the patch
# - manually clone butler, change go.mod's version number to 1.18 at least
# - run `go mod tidy` in the cloned repository.
# - generate patch with `git diff > go.mod.patch`

buildGoModule rec {
  pname = "butler";
  version = "15.24.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${version}";
    hash = "sha256-Gzf+8icPIXrNc8Vk8z0COPv/QA6GL6nSvQg13bAlfZM=";
  };

  buildInputs = [ brotli ];

  patches = [ ./go.mod.patch ];

  doCheck = false; # disabled because the tests don't work in a non-FHS compliant environment.

  vendorHash = "sha256-A6u7bKI7eoptkjBuXoQlLYHkEVtrl8aNnBb65k1bFno=";

  meta = {
    description = "Command-line itch.io helper";
    changelog = "https://github.com/itchio/butler/releases/tag/v${version}/CHANGELOG.md";
    homepage = "http://itch.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
  };
}
