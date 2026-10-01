{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "git-pkgs-forge";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "forge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z3T/FzY+9D1156kRuiTzPX1S6ZidYnuqUWFdP5pNtMg=";
  };

  vendorHash = "sha256-iJ3igNOEbuMaW++yoNVHX29RlGneuFySZ/dm1F9+jec=";

  ldflags = [
    "-s"
    "-X github.com/git-pkgs/forge/internal/cli.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Go library and CLI for working with git forges";
    mainProgram = "forge";
    homepage = "https://github.com/git-pkgs/forge";
    changelog = "https://github.com/git-pkgs/forge/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yamashitax ];
  };
})
