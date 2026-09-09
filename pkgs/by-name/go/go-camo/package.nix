{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  scdoc,
}:

buildGoModule rec {
  pname = "go-camo";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = "go-camo";
    tag = "v${version}";
    hash = "sha256-QFCvsX+F8OclFrRME0STRThkS/UvkMJovWJrKKaptgY=";
  };

  vendorHash = "sha256-s+2tt0e93KeEcc3sWx94c2p5d684lwxn/vzsdRDWLxE=";

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.ServerVersion=${version}"
  ];

  postBuild = ''
    make man
  '';

  postInstall = ''
    installManPage build/man/*
  '';

  preCheck = ''
    # requires network access
    rm pkg/camo/proxy_{,filter_}test.go
  '';

  passthru.tests = {
    inherit (nixosTests) go-camo;
  };

  meta = {
    description = "Camo server is a special type of image proxy that proxies non-secure images over SSL/TLS";
    homepage = "https://github.com/cactus/go-camo";
    changelog = "https://github.com/cactus/go-camo/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "go-camo";
    maintainers = with lib.maintainers; [ viraptor ];
  };
}
