{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "bitbucket-cli";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "swisscom";
    repo = "bitbucket-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hcfvVmqdnCaTdazN1Jq0+K8U9zdSATTm4ui8x2abZhM=";
  };

  vendorHash = "sha256-xjCY3Ycz5Ty6jTDHNNUWYp2SP8EPhDiwO7+WJBL3lAQ=";

  # Tests seem to be using Swisscom's live servers.
  doCheck = false;

  meta = {
    description = "Bitbucket Enterprise CLI";
    homepage = "https://github.com/swisscom/bitbucket-cli";
    mainProgram = "bitbucket-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
