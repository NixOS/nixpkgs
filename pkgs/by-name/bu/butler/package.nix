{
  buildGoModule,
  brotli,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "butler";
  version = "15.30.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zq6ZmPNhRrp2MiDr6VElPMJGXEEkdK9ZjI0XUM0nED8=";
  };

  buildInputs = [ brotli ];

  doCheck = false; # disabled because the tests don't work in a non-FHS compliant environment.

  vendorHash = "sha256-kNc3twHNWgxJEVDte4GO6da8KrUmClaFZuip1bb1fMM=";

  meta = {
    description = "Command-line itch.io helper";
    changelog = "https://github.com/itchio/butler/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "http://itch.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
  };
})
