{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "copacetic";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "project-copacetic";
    repo = "copacetic";
    rev = "refs/tags/v${version}";
    hash = "sha256-hvSbjkqrd//thUex2It31Z4Vrj1u07WEAQFAnWiPo6M=";
  };

  vendorHash = "sha256-eefYbB88wXQME8ehm/ieVBtOmmtxHkZSsjE05yeQ7Gw=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/project-copacetic/copacetic/pkg/version.GitVersion=${version}"
    "-X main.version=${version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestNewClient/custom_buildkit_addr"
        "TestPatch"
        "TestPlugins/docker.io"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  postInstall =
    ''
      mv $out/bin/copacetic $out/bin/copa
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd copa \
        --bash <($out/bin/copa completion bash) \
        --fish <($out/bin/copa completion fish) \
        --zsh <($out/bin/copa completion zsh)
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://project-copacetic.github.io/copacetic/";
    description = "Tool for directly patching vulnerabilities in container images";
    license = lib.licenses.asl20;
    mainProgram = "copa";
    maintainers = with lib.maintainers; [ bmanuel ];
  };
}
