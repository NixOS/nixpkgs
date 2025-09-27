{
  # go-arch-lint has historically required code changes to support new versions of
  # go so always use the latest specific go version that go-arch-lint supports
  # rather than buildGoLatestModule.
  # This can be bumped when the release notes of go-arch-lint detail support for
  # new version of go.
  buildGo125Module,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGo125Module (finalAttrs: {
  pname = "go-arch-lint";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "fe3dback";
    repo = "go-arch-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TtYeowoL8NEOw1coiLHJ/epcFMaxT4zsBSsnLgmhKDc=";
  };

  vendorHash = "sha256-2n7OjF4gl+qq9M5EtU0nmgWwRPZ3YvmLQDAgJ8w9S1M=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/fe3dback/${finalAttrs.pname}/internal/app.Version=${finalAttrs.version}"
    "-X github.com/fe3dback/${finalAttrs.pname}/internal/app.CommitHash=v${finalAttrs.version}"
    "-X github.com/fe3dback/${finalAttrs.pname}/internal/app.BuildTime=19700101-00:00:00"
  ];

  postInstall =
    let
      goarchlintBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.go-arch-lint;
    in
    ''
      installShellCompletion --cmd go-arch-lint \
        --bash <(${goarchlintBin}/bin/go-arch-lint completion bash) \
        --fish <(${goarchlintBin}/bin/go-arch-lint completion fish) \
        --zsh <(${goarchlintBin}/bin/go-arch-lint completion zsh)
    '';

  meta = {
    description = "GoLang architecture linter (checker) tool. Will check all project import path and compare with arch rules defined in yml file";
    homepage = "https://github.com/fe3dback/go-arch-lint";
    changelog = "https://github.com/fe3dback/go-arch-lint/releases/tag/v${finalAttrs.version}";
    mainProgram = "go-arch-lint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fe3dback
    ];
  };
})
