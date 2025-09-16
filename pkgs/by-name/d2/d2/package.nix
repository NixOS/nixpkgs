{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  testers,
  d2,
}:

buildGoModule (finalAttrs: {
  pname = "d2";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZRAvMcJKQmvcBbT2foKDYS0gTeqOZqFu3V3iXIbfLsQ=";
  };

  vendorHash = "sha256-UZDk2upJ0xTSAg/DpRHCzdAOLnaeI0WLMJ6jNt8elKI=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    # See https://github.com/terrastruct/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
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
    changelog = "https://github.com/terrastruct/d2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dit7ya
      kashw2
    ];
  };
})
