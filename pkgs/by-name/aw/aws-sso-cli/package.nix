{
  buildGoModule,
  fetchFromGitHub,
  getent,
  installShellFiles,
  lib,
  makeWrapper,
  stdenv,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:
buildGoModule (finalAttrs: {
  pname = "aws-sso-cli";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = "aws-sso-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u9fgfLhsdpEQ9T1T8jbGWl87vu61bWX9SzELktihBg8=";
  };
  vendorHash = "sha256-lpp3Fji/EChMukRpypN98h9c5iN5z2S9RyrghFpxLbk=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
    "-X main.Tag=nixpkgs"
  ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd aws-sso \
      --bash <($out/bin/aws-sso setup completions --source --shell=bash) \
      --fish <($out/bin/aws-sso setup completions --source --shell=fish) \
      --zsh <($out/bin/aws-sso setup completions --source --shell=zsh)
  '';

  nativeCheckInputs = [
    getent
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    mkdir -p "$HOME/.config/aws-sso"
  '';

  checkFlags =
    let
      skippedTests = [
        "TestAWSFederatedUrl"
        "TestAWSConsoleUrlChina"
        "TestAWSConsoleUrlEU"
        "TestAWSConsoleUrlUSEast"
        "TestAWSConsoleUrlUSGov"
        "TestGetScriptsAutoDetect"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "TestDetectShellBash" ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
})
