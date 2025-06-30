{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goimports-reviser";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "incu6us";
    repo = "goimports-reviser";
    rev = "v${version}";
    hash = "sha256-MMF5gzUbL8j9NTGKT1Xz177Z0SqdeKObBa6TEguK5aI=";
  };
  vendorHash = "sha256-BAV7vMWRgBZaL2Pya4QiVcY54VIiHT++Dz4ZZ92FGgM=";

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Tag=${src.rev}"
  ];

  checkFlags = [
    "-skip=TestSourceFile_Fix_WithAliasForVersionSuffix/success_with_set_alias"
  ];

  preCheck = ''
    # unset to run all tests
    unset subPackages
    # unset as some tests require cgo
    unset CGO_ENABLED
  '';

  meta = with lib; {
    description = "Right imports sorting & code formatting tool (goimports alternative)";
    mainProgram = "goimports-reviser";
    homepage = "https://github.com/incu6us/goimports-reviser";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
