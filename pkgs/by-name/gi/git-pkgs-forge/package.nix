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
    rev = "v${finalAttrs.version}";
    hash = "sha256-z3T/FzY+9D1156kRuiTzPX1S6ZidYnuqUWFdP5pNtMg=";
  };
  vendorHash = "sha256-iJ3igNOEbuMaW++yoNVHX29RlGneuFySZ/dm1F9+jec=";

  meta = {
    description = "Go library and CLI for working with git forges. Supports GitHub, GitLab, Gitea/Forgejo, and Bitbucket Cloud through a single interface.";
    mainProgram = "forge";
    homepage = "https://github.com/git-pkgs/forge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yamashitax ];
  };
})
