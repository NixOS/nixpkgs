{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,

  writableTmpDirAsHomeHook,

  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "stripe-cli";
  version = "1.31.0";

  # required for tests
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "stripe-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fvemd1yo8WOWob/l3TU9lHcFc7OAI/oaX5XEK38vDwo=";
  };
  vendorHash = "sha256-EDdRgApJ7gv/4ma/IfaHi+jjpTPegsUfqHbvoFMn048=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    # required by pkg/rpcservice/sample_create_test.go
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # the tests expect the Version ldflag not to be set
    unset ldflags
  ''
  +
    lib.optionalString
      (
        # delete plugin tests on all platforms but exact matches
        # https://github.com/stripe/stripe-cli/issues/850
        # https://github.com/stripe/stripe-cli/blob/e3020d2e2df9c731b2f51df3aa53bf16383e863f/pkg/plugins/test_artifacts/plugins.toml
        !lib.lists.any (platform: lib.meta.platformMatch stdenv.hostPlatform platform) [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ]
      )
      ''
        rm pkg/plugins/plugin_test.go
      '';

  checkFlags =
    let
      skippedTests = [
        # network access
        "TestConflictWithPluginCommand"
        "TestLogin"

        # not providing git or the various editors it wants to call
        "TestGetOpenEditorCommand"
        "TestGetDefaultGitEditor"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  postInstall =
    let
      inherit (finalAttrs.meta) mainProgram;
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/${mainProgram}"
        else
          lib.getExe buildPackages.stripe-cli;
    in
    ''
      # only outputs bash and zsh completion
      installShellCompletion --cmd ${mainProgram} \
        --bash <(${exe} completion --write-to-stdout --shell bash) \
        --zsh <(${exe} completion --write-to-stdout --shell zsh)
    '';

  meta = {
    homepage = "https://stripe.com/docs/stripe-cli";
    changelog = "https://github.com/stripe/stripe-cli/releases/tag/${finalAttrs.src.tag}";
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
