{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  ipatool,
}:

buildGoModule (finalAttrs: {
  pname = "ipatool";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "majd";
    repo = "ipatool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ME3fvYziI3fjlQ0KBPMJJXsCG3hW0z2iz1gKoBh0grk=";
  };

  vendorHash = "sha256-TmP7NjDrxTcsnVU9Hi4S1wXSzQNCJOVH02j5QpjvMgw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/majd/ipatool/v2/cmd.version=${finalAttrs.version}"
  ];

  # go generate ./... fails because of a missing module: github.com/golang/mock/mockgen
  # which is required to run the tests, check if next release fixes it.
  # preCheck = ''
  #   go generate ./...
  # '';
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = ipatool;
      command = "ipatool --version";
    };
  };

  meta = {
    description = "Command-line tool that allows searching and downloading app packages (known as ipa files) from the iOS App Store";
    homepage = "https://github.com/majd/ipatool";
    changelog = "https://github.com/majd/ipatool/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ipatool";
  };
})
