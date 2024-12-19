{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "keep-sorted";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    rev = "v${version}";
    hash = "sha256-xvSEREEOiwft3fPN+xtdMCh+z3PknjJ962Nb+pw715U=";
  };

  vendorHash = "sha256-HTE9vfjRmi5GpMue7lUfd0jmssPgSOljbfPbya4uGsc=";

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  preCheck = ''
    # Test tries to find files using git in init func.
    rm goldens/*_test.go
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/google/keep-sorted/releases/tag/v${version}";
    description = "Language-agnostic formatter that sorts lines between two markers in a larger file";
    homepage = "https://github.com/google/keep-sorted";
    license = lib.licenses.asl20;
    mainProgram = "keep-sorted";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
