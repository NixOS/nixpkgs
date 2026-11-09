{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  git,
  testers,
  d2,
}:

buildGo127Module (finalAttrs: {
  pname = "d2";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "d2lang";
    repo = "d2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HhCktLU43Y/uje038axwO7tNqO353mV/JID223sBtd8=";
  };

  # d2renderers/d2raster's TestRasterPackageHasNoIOCapabilities shells out to
  # `go list -mod=readonly -deps`, which bypasses the vendor directory and needs
  # a populated module cache.
  proxyVendor = true;
  vendorHash = "sha256-6rrFjboeJ2Qln5TxbsJKmyTclIh1gz1X91g5IFjbMKo=";

  excludedPackages = [
    "./ci"
    "./e2etests"
    "./e2etests-cli"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/d2lang/d2/lib/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  preCheck = ''
    # See https://github.com/d2lang/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
    export TESTDATA_ACCEPT=1
  '';

  passthru.tests.version = testers.testVersion {
    package = d2;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Modern diagram scripting language that turns text to diagrams";
    mainProgram = "d2";
    homepage = "https://d2lang.com";
    changelog = "https://github.com/d2lang/d2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
