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
  version = "1.8.0";

  vendorHash = "sha256-H2IakJKaX/LzD+vzkGWK9YuCKvBfnKCZT6bm1zDaWeY=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = "shiori";
    rev = "v${version}";
    sha256 = "sha256-oycD/Tyl3+CGW9EO0O4RHKONLt3mw2lzPEYELYNG0gw=";
  };

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=nixpkgs-${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
