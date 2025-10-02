{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "stripe-cli";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "stripe-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fvemd1yo8WOWob/l3TU9lHcFc7OAI/oaX5XEK38vDwo=";
  };
  vendorHash = "sha256-EDdRgApJ7gv/4ma/IfaHi+jjpTPegsUfqHbvoFMn048=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    # the tests expect the Version ldflag not to be set
    unset ldflags

    # requires internet access
    rm pkg/cmd/plugin_cmds_test.go
    rm pkg/cmd/resources_test.go
    rm pkg/cmd/root_test.go

    # TODO: no clue why it's broken (1.17.1), remove for now.
    rm pkg/login/client_login_test.go
    rm pkg/git/editor_test.go
    rm pkg/rpcservice/sample_create_test.go
  ''
  +
    lib.optionalString
      (
        # delete plugin tests on all platforms but exact matches
        # https://github.com/stripe/stripe-cli/issues/850
        !lib.lists.any (platform: lib.meta.platformMatch stdenv.hostPlatform platform) [
          "x86_64-linux"
          "x86_64-darwin"
        ]
      )
      ''
        rm pkg/plugins/plugin_test.go
      '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd stripe \
      --bash <($out/bin/stripe completion --write-to-stdout --shell bash) \
      --zsh <($out/bin/stripe completion --write-to-stdout --shell zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/stripe --help
    $out/bin/stripe --version | grep "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://stripe.com/docs/stripe-cli";
    changelog = "https://github.com/stripe/stripe-cli/releases/tag/v${finalAttrs.version}";
    description = "Command-line tool for Stripe";
    longDescription = ''
      The Stripe CLI helps you build, test, and manage your Stripe integration
      right from the terminal.

      With the CLI, you can:
      Securely test webhooks without relying on 3rd party software
      Trigger webhook events or resend events for easy testing
      Tail your API request logs in real-time
      Create, retrieve, update, or delete API objects.
    '';
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      RaghavSood
      jk
      kashw2
    ];
    mainProgram = "stripe";
  };
})
