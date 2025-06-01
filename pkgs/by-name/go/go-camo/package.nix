{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
}:

buildGo124Module rec {
  pname = "go-camo";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = "go-camo";
    rev = "v${version}";
    hash = "sha256-uf/r+QDukuFbbsFQal0mfZaGHZYk1fGn8Kt1ipFD/vI=";
  };

  vendorHash = "sha256-PQ9Q+xaziTASH361qeBW0mVDtcXwU3/Sm/V/O4T2AP8=";

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
