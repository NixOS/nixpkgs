{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  stdenv,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:
buildGoModule (finalAttrs: {
  pname = "aws-vault";
  version = "7.17.5";

  src = fetchFromGitHub {
    owner = "ByteNess";
    repo = "aws-vault";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bphIxxvXkWPfFfntN5xKOaxFhgMEFFQc8q2veLta4sE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UWNn1Cd3vwviAF54BL/EOJrzZ3n8mxY9kFKUjkXxyvI=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    writableTmpDirAsHomeHook
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
    "-X main.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/aws-vault --version 2>&1 | grep ${finalAttrs.version} > /dev/null
  '';

  meta = {
    description = "Vault for securely storing and accessing AWS credentials in development environments";
    mainProgram = "aws-vault";
    homepage = "https://github.com/ByteNess/aws-vault";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zimbatm
      er0k
    ];
  };
})
