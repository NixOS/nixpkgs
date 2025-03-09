{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "go-passbolt-cli";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "go-passbolt-cli";
    rev = "v${version}";
    hash = "sha256-I+niNUowKTFDMa7yOnRToMFPzO/CbnjXHJr5nAhhHcg=";
  };

  vendorHash = "sha256-XRHGq3Qeq7VWHzw5WWVv4x5orQu740lttGVreiu7qP4=";

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
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

  meta = with lib; {
    description = "CLI tool to interact with Passbolt, an open source password manager for teams";
    homepage = "https://github.com/passbolt/go-passbolt-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek ];
    mainProgram = "passbolt";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
