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
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = "go-camo";
    tag = "v${version}";
    hash = "sha256-+EHJIohHSWg12Tmn6hu1XUSVRyYWu3aFI7MF7+PnfFg=";
  };

  vendorHash = "sha256-rKdBAu0tNsxw7I66qjZhtrA2hs1qpBtOSuzq34paziw=";

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
