{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "imgpkg";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "imgpkg";
    rev = "v${version}";
    hash = "sha256-DuLxNH0fcVPvZYG4AYtaT8kJysTLRNX2tB6UBhQoP9Q=";
  };

  vendorHash = null;

  subPackages = [ "cmd/imgpkg" ];

  env.CGO_ENABLED = "0";
  ldflags = [ "-X=carvel.dev/imgpkg/pkg/imgpkg/cmd.Version=${version}" ];

  meta = {
    description = "Store application configuration files in Docker/OCI registries";
    homepage = "https://carvel.dev/imgpkg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benchand ];
    mainProgram = "imgpkg";
  };
}
