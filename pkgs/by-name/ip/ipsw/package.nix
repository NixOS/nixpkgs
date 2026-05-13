{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module (finalAttrs: {
  version = "3.1.672";
  pname = "ipsw";

  src = fetchFromGitHub {
    owner = "blacktop";
    repo = "ipsw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzxhTWd3aVB3RQLWajhKXlwgVvn/PgoL1+ovYO/IleA=";
  };

  vendorHash = "sha256-cyHfH/Ljz4wuMdKkSfySSK5kPRwq9M1+C/5CG5VwHoE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion==${finalAttrs.version}"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit==${finalAttrs.src.tag}"
  ];

  subPackages = [
    "cmd/ipsw"
  ];

  meta = {
    description = "iOS/macOS Research Swiss Army Knife";
    homepage = "https://blacktop.github.io/ipsw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.viraptor ];
    platforms = lib.platforms.unix;
    mainProgram = "ipsw";
  };
})
