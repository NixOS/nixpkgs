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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-37wYYB0k8mhQq30y1oo77qW3bIqqN/K/NG1RgxK6dyI=";
  };

  vendorHash = "sha256-T6/xEXv8+io3XwQ2keacpYYIdTnYhTTUCojf62tTwbA=";

  env.CGO_ENABLED = "0";

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
