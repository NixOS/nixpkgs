{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "go-passbolt-cli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "go-passbolt-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uccHe82p+56RV4tyZINFH0ilEdVREpZuxXXc7N5Vpgo=";
  };

  vendorHash = "sha256-pjmKjTMPbjU0bI9+0YcwaIwoU2TG2NdWvNo9Uh3EHSA=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/go-passbolt-cli $out/bin/passbolt
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd passbolt \
      --bash <($out/bin/passbolt completion bash) \
      --fish <($out/bin/passbolt completion fish) \
      --zsh <($out/bin/passbolt completion zsh)

    export tmpDir=$(mktemp -d)
    cd $tmpDir && mkdir man && $out/bin/passbolt gendoc --type man && installManPage man/*
  '';

  meta = {
    description = "CLI tool to interact with Passbolt, an open source password manager for teams";
    homepage = "https://github.com/passbolt/go-passbolt-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "passbolt";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
