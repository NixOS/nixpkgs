{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "shiori";
  version = "1.7.2";

  vendorHash = "sha256-RTnaDAl79LScbeKKAGJOI/YOiHEwwlxS2CmNhw80KL0=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QNcMPeLq5L7Q+nmADWZnl4wV5oM6v+NZbAFsba2fKCk=";
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
    maintainers = with maintainers; [
      minijackson
      CaptainJawZ
    ];
  };
}
