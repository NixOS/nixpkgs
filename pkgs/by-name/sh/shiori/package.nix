{ lib, buildGoModule, fetchFromGitHub, nixosTests, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "shiori";
  version = "1.7.1";

  vendorHash = "sha256-fakRqgoEcdzw9WZuubaxfGfvVrMvb8gV/IwPikMnfRQ=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gMIpDiA5ncZ50WZ2Y57mScTEXzeObgZxP+nkWe+a8Eo=";
  };

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=nixpkgs-${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    installShellCompletion --cmd shiori \
      --bash <($out/bin/shiori completion bash) \
      --fish <($out/bin/shiori completion fish) \
      --zsh <($out/bin/shiori completion zsh)
  '';

  passthru.tests.smoke-test = nixosTests.shiori;

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    mainProgram = "shiori";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson CaptainJawZ ];
  };
}
