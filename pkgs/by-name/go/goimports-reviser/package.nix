{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goimports-reviser";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "incu6us";
    repo = "goimports-reviser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5v10DmJovyDyfAlgLuO4uCKRDZGIUxGLHFJRHsGmSm4=";
  };
  vendorHash = "sha256-aTPzvqIwjZzEq9LHFdebIgbKMwsBOqLbpEWB7rN7cYY=";

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Tag=${finalAttrs.src.rev}"
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

  meta = {
    description = "Right imports sorting & code formatting tool (goimports alternative)";
    mainProgram = "goimports-reviser";
    homepage = "https://github.com/incu6us/goimports-reviser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk ];
  };
})
