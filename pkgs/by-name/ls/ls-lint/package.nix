{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ls-lint";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PlWYTwMTu5rffBuynUWExtxSV6BLNz4qox4caiWs7kw=";
  };

  vendorHash = "sha256-UN8UpUph9SOGfdrxr9CfvQULBphG3mR5DJ06EHN+J5k=";

  meta = {
    description = "Extremely fast file and directory name linter";
    mainProgram = "ls_lint";
    homepage = "https://ls-lint.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
})
