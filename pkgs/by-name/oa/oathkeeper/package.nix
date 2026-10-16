{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "oathkeeper";
  version = "26.2.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "oathkeeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dux9g5AWnbj9kXoIogVneOYywgg9TnyXqP41YT/1C8k=";
  };

  vendorHash = "sha256-/Qgdes8EAxP9FDKbahQdCpAD7PSe4iCkUvL1+poqaWc=";

  __structuredAttrs = true;
  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "..." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-X github.com/ory/oathkeeper/x.Version=${finalAttrs.src.tag}"
    "-X github.com/ory/oathkeeper/x.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  # upstream tests use dynamic port assignment
  __darwinAllowLocalNetworking = true;

  # The configuration contains values or keys which are invalid:
  # version:
  #          ^-- does not match pattern "^v(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
  preCheck = ''
    export version="${finalAttrs.src.tag}"
  '';
  checkFlags =
    let
      skippedTests = [
        # flaky test, if system under high load the underlying server may be unavailable
        "TestAuthenticatorOAuth2Introspection"
        # flaky test(s): likely due to race condition within parallel test run, revisit at later date
        # Error:          Expected nil, but got: &oauth2.Token{AccessToken:"some-token", TokenType:"Bearer", RefreshToken:"", Expiry:time.Date(2026, time.June, 24, 22, 41, 47, 887223251, time.UTC), ExpiresIn:0, raw:interface {}(nil), expiryDelta:0}
        "TestClientCredentialsCache"
        # Error: Not equal:
        #     expected: rule.Rule{ID:"foo2", Version:"", Description:"Get users rule", Match:(*rule.Match)(0x64e4fd34c30), Authenticators>
        #     actual  : rule.Rule{ID:"foo2", Version:"v26.2.0", Description:"Get users rule", Match:(*rule.Match)(0x64e4ff56ed0), Authent>
        "TestHandler"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd oathkeeper \
      --bash <($out/bin/oathkeeper completion bash) \
      --fish <($out/bin/oathkeeper completion fish) \
      --zsh <($out/bin/oathkeeper completion zsh)
  '';
  meta = {
    description = "Identity and access proxy that authorizes HTTP requests based on sets of rules";
    longDescription = ''
      It follows
      [cloud architecture best practices](https://www.ory.com/docs/ecosystem/software-architecture-philosophy) and focuses on:

      - Authenticating and authorizing HTTP requests
      - Acting as a reverse proxy or decision API
      - Mutating requests with identity information
      - Integrating with existing API gateways and proxies
      - Supporting multiple authentication and authorization strategies
      - Working in Zero-Trust network architectures
    '';
    homepage = "https://github.com/ory/oathkeeper";
    changelog = "https://github.com/ory/oathkeeper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      camcalaquian
      debtquity
    ];
    mainProgram = "oathkeeper";
  };
})
