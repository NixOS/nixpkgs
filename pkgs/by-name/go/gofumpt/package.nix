{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, gofumpt
}:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-94aaLqoalFredkxaSPgJEnFtKw7GmkkL5N+I8ws9zxY=";
  };

  vendorHash = "sha256-q8+Blzab9TLTRY2/KncIlVp53+K6YWzg1D0SS7FPM9I=";

  CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
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
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    changelog = "https://github.com/mvdan/gofumpt/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs katexochen ];
    mainProgram = "gofumpt";
  };
}
