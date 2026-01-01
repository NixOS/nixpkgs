{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
<<<<<<< HEAD

  writableTmpDirAsHomeHook,

  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "stripe-cli";
  version = "1.31.0";

  # required for tests
  __darwinAllowLocalNetworking = true;
=======
}:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.30.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "stripe-cli";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-fvemd1yo8WOWob/l3TU9lHcFc7OAI/oaX5XEK38vDwo=";
=======
    rev = "v${version}";
    hash = "sha256-qDrEDP3gDHggXxavMVuVitFN+OWz5WlamePS/1/zlq8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  vendorHash = "sha256-EDdRgApJ7gv/4ma/IfaHi+jjpTPegsUfqHbvoFMn048=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    # required by pkg/rpcservice/sample_create_test.go
    writableTmpDirAsHomeHook
=======
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preCheck = ''
    # the tests expect the Version ldflag not to be set
    unset ldflags
<<<<<<< HEAD
=======

    # requires internet access
    rm pkg/cmd/plugin_cmds_test.go
    rm pkg/cmd/resources_test.go
    rm pkg/cmd/root_test.go

    # TODO: no clue why it's broken (1.17.1), remove for now.
    rm pkg/login/client_login_test.go
    rm pkg/git/editor_test.go
    rm pkg/rpcservice/sample_create_test.go
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ''
  +
    lib.optionalString
      (
        # delete plugin tests on all platforms but exact matches
        # https://github.com/stripe/stripe-cli/issues/850
<<<<<<< HEAD
        # https://github.com/stripe/stripe-cli/blob/e3020d2e2df9c731b2f51df3aa53bf16383e863f/pkg/plugins/test_artifacts/plugins.toml
        !lib.lists.any (platform: lib.meta.platformMatch stdenv.hostPlatform platform) [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
=======
        !lib.lists.any (platform: lib.meta.platformMatch stdenv.hostPlatform platform) [
          "x86_64-linux"
          "x86_64-darwin"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        ]
      )
      ''
        rm pkg/plugins/plugin_test.go
      '';

<<<<<<< HEAD
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
=======
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd stripe \
      --bash <($out/bin/stripe completion --write-to-stdout --shell bash) \
      --zsh <($out/bin/stripe completion --write-to-stdout --shell zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/stripe --help
    $out/bin/stripe --version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://stripe.com/docs/stripe-cli";
    changelog = "https://github.com/stripe/stripe-cli/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
