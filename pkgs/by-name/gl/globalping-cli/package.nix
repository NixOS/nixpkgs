{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "globalping-cli";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "jsdelivr";
    repo = "globalping-cli";
    rev = "v${version}";
    hash = "sha256-muWhiKqPdNVhy7c7MSRHACGzOn5pIVRdqSdfdCJw2CA=";
  };

  vendorHash = "sha256-dJAuN5srL5EvMaRg8rHaTsurjYrdH45p965DeubpB0E=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

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

  meta = with lib; {
    description = "Simple CLI tool to run networking commands remotely from hundreds of globally distributed servers";
    homepage = "https://www.jsdelivr.com/globalping/cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "globalping";
  };
}
