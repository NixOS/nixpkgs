{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  gofumpt,
}:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mJM0uKztX0OUQvynnxeKL9yft7X/Eh28ERg8SbZC5Ws=";
  };

  vendorHash = "sha256-kJysyxROvB0eMAHbvNF+VXatEicn4ln2Vqkzp7GDWAQ=";

  CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X main.version=v${version}"
  ];

  checkFlags = [
    # Requires network access (Error: module lookup disabled by GOPROXY=off).
    "-skip=^TestScript/diagnose$"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = gofumpt;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    changelog = "https://github.com/mvdan/gofumpt/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      rvolosatovs
      katexochen
    ];
    mainProgram = "gofumpt";
  };
}
