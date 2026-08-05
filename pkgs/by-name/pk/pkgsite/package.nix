{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.3.0-unstable-2026-08-04";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "9175adf713dbdc79186cb3531996bc6ba3ca355f";
    hash = "sha256-qDTNb3HPoPtrYI4BoNA+JWwfRtrUacBpeeHeTCCfUl4=";
  };

  vendorHash = "sha256-NZzA9QxVSYuSjeZOiwUAXAPBrN00JLHQNPp1lXqtmCw=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
