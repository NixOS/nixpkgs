{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  stdenv,
  xdg-utils,
}:
buildGoModule rec {
  pname = "aws-vault";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qs4vxFgehWQYYECBGBSU8YI/BHLwOQUO5wBlNEUzD7c=";
  };

  vendorHash = "sha256-4bJKDEZlO0DzEzTQ7m+SQuzhe+wKmL6wLueqgSz/46s=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    # make xdg-open overrideable at runtime
    # aws-vault uses https://github.com/skratchdot/open-golang/blob/master/open/open.go to open links
    ${lib.optionalString (
      !stdenv.hostPlatform.isDarwin
    ) "wrapProgram $out/bin/aws-vault --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"}
    installShellCompletion --cmd aws-vault \
      --bash $src/contrib/completions/bash/aws-vault.bash \
      --fish $src/contrib/completions/fish/aws-vault.fish \
      --zsh $src/contrib/completions/zsh/aws-vault.zsh
  '';

  doCheck = false;

  subPackages = [ "." ];

  # set the version. see: aws-vault's Makefile
  ldflags = [
    "-X main.Version=v${version}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/aws-vault --version 2>&1 | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A vault for securely storing and accessing AWS credentials in development environments";
    mainProgram = "aws-vault";
    homepage = "https://github.com/99designs/aws-vault";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
