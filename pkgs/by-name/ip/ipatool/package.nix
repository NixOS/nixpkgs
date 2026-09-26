{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  ipatool,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "ipatool";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "majd";
    repo = "ipatool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jIdjTDs/g41j805vkC1PqLvChtzB055JYmd4GbEHNZU=";
  };

  vendorHash = "sha256-HNus5wZUmiuVVdDj4i9X9sO8iyccrq4h//s0zkQNYjY=";

  # Fixes "import lookup disabled by -mod=vendor" for onepassword-sdk-go on macOS
  proxyVendor = true;

  # Fixes "unable to open output file '/homeless-shelter/.cache/clang/ModuleCache/" on macOS
  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

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
