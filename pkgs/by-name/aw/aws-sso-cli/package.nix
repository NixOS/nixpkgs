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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = "aws-sso-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JFaCTgvH6qzQ8gMt5QgqAPBal2m8FZEemTgbqyECFck=";
  };
  vendorHash = "sha256-f9qSnEOUw8QWbc0rgStyzuL6lWtfy3UFhjqDAnJkKJA=";

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
