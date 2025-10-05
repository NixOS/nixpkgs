{
  buildGoModule,
  fetchFromGitHub,
  getent,
  installShellFiles,
  lib,
  makeWrapper,
  stdenv,
  xdg-utils,
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = "aws-sso-cli";
    rev = "v${version}";
    hash = "sha256-MomH4Zcc6iyVmLfA0PPsWgEqMBAAaPd+21NX4GdnFk0=";
  };
  vendorHash = "sha256-Le5BOD/iBIMQwTNmb7JcW8xJS7WG5isf4HXpJxyvez0=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  ldflags = [
    "-X main.Version=${version}"
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

  nativeCheckInputs = [ getent ];

  checkFlags =
    let
      skippedTests = [
        "TestAWSConsoleUrl"
        "TestAWSFederatedUrl"
        "TestServerWithSSL" # https://github.com/synfinatic/aws-sso-cli/issues/1030 -- remove when version >= 2.x
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "TestDetectShellBash" ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
