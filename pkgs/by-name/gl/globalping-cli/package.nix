{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "globalping-cli";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jsdelivr";
    repo = "globalping-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+WsMrA/OI82IQrmN8LpW1jzZjM3M6GU0PYc9aowZclE=";
  };

  vendorHash = "sha256-HFgWH6kcCv3voyiWkcaNiK3NvnQlgop9DLC1o0xeSN0=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        # Skip tests that require network access
        "Test_Authorize"
        "Test_TokenIntrospection"
        "Test_Logout"
        "Test_RevokeToken"
        "Test_Limits"
        "Test_CreateMeasurement"
        "Test_GetMeasurement"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "|^" skippedTests}" ];

  postInstall = ''
    mv $out/bin/globalping-cli $out/bin/globalping
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd globalping \
      --bash <($out/bin/globalping completion bash) \
      --fish <($out/bin/globalping completion fish) \
      --zsh <($out/bin/globalping completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple CLI tool to run networking commands remotely from hundreds of globally distributed servers";
    homepage = "https://www.jsdelivr.com/globalping/cli";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ xyenon ];
    mainProgram = "globalping";
  };
})
