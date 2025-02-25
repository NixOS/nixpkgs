{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
}:

buildGo124Module rec {
  pname = "go-camo";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f4XviRqu4muc2owwV3p7y5Rehl1jrf0jDhQQvGxnw7M=";
  };

  vendorHash = "sha256-s6OPmtTx2/AxSm6Y0UjYORSuozPUemGyfdtv1NNlZHc=";

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

  meta = with lib; {
    description = "Camo server is a special type of image proxy that proxies non-secure images over SSL/TLS";
    homepage = "https://github.com/cactus/go-camo";
    changelog = "https://github.com/cactus/go-camo/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "go-camo";
    maintainers = with maintainers; [ viraptor ];
  };
}
