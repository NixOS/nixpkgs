{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  scdoc,
}:

buildGo124Module rec {
  pname = "go-camo";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = "go-camo";
    tag = "v${version}";
    hash = "sha256-BdKIfDDN6GXc53SFDkJ8Dui5rrm27blA+EEOS/oAanE=";
  };

  vendorHash = "sha256-0DkIbD+9gIbARqvmudRavwcWVLADGKwEYMMX6a5Qoq4=";

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
