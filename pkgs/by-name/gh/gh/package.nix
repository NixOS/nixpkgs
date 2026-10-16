{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  installShellFiles,
  stdenv,
  versionCheckHook,
  makeWrapper,

  writableTmpDirAsHomeHook,
  git,
  openssh,
}:

buildGo127Module (finalAttrs: {
  pname = "gh";
  version = "2.102.0";

  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9H1Y+e1V4n9hEHa6B/mrygThbfITN+JyG8DSzXJTfYU=";

    postCheckout = ''
      git -C "$out" log -1 --pretty=%ct > $out/SOURCE_DATE_EPOCH
    '';
  };

  vendorHash = "sha256-hsG6wc7AfgPZhkWwO8Xzu4yR54Rp5+Z6yeTjwnI9S+o=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # N.B.: using make (via the generic buildPhase) is intentional.
  buildPhase = null;

  # The custom build script (script/build.go) invoked by make will pick up SOURCE_DATE_EPOCH.
  # It is used as the build date given by gh --version.
  postPatch = ''
    export SOURCE_DATE_EPOCH=$(cat SOURCE_DATE_EPOCH)
  '';

  makeFlags = [
    "bin/gh"
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "manpages"
  ];

  env.GH_VERSION = finalAttrs.version;

  installPhase = ''
    runHook preInstall
    installBin bin/gh
    wrapProgram $out/bin/gh \
      --set-default GH_TELEMETRY false
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  ''
  + ''
    runHook postInstall
  '';

  nativeCheckInputs = [
    openssh
    git
    writableTmpDirAsHomeHook
  ];
  doCheck = true;
  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck;
  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    downloadPage = "https://github.com/cli/cli";
    changelog = "https://github.com/cli/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "gh";
    maintainers = with lib.maintainers; [
      mdaniels5757
      zowoq
      savtrip
    ];
  };
})
