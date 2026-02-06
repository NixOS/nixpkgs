{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  scdoc,
}:

buildGo125Module rec {
  pname = "go-camo";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = "go-camo";
    tag = "v${version}";
    hash = "sha256-LP01sPTHDouUmp6iDxdPklunxYKak2vaL0gJZsO3QRM=";
  };

  vendorHash = "sha256-lFpVlK5/LSRTxVD5Ve6DSACeyLFTJxDM2bDTxcUU73E=";

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
