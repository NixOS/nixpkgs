{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "go-passbolt-cli";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "go-passbolt-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EytU20jdrfXwuoofp8OAphX9jjUoFpKva75PBDIFDD8=";
  };

  vendorHash = "sha256-HbwGF9ZTwWdJf7XnUKnS1n58GSaPTRlblXAmtKQoooU=";
=======
    hash = "sha256-BtMPOmp9dbi/HoNigEeGWIYXRh1/gorV8ycrtWw9I8s=";
  };

  vendorHash = "sha256-wGSrhW7OsSjHlSKLkOf2AYIxU1m2lM1WGUsy16qxBwA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "CLI tool to interact with Passbolt, an open source password manager for teams";
    homepage = "https://github.com/passbolt/go-passbolt-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "passbolt";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
  meta = with lib; {
    description = "CLI tool to interact with Passbolt, an open source password manager for teams";
    homepage = "https://github.com/passbolt/go-passbolt-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek ];
    mainProgram = "passbolt";
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
