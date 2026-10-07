{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "imgpkg";
  version = "0.48.2";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "imgpkg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YNd4OApC1m8HqUFuwlePEiH1wDR1RjA5V3A/a+IGvs8=";
  };

  vendorHash = null;

  subPackages = [ "cmd/imgpkg" ];

  env.CGO_ENABLED = "0";
  ldflags = [ "-X=carvel.dev/imgpkg/pkg/imgpkg/cmd.Version=${finalAttrs.version}" ];

  meta = {
    description = "Store application configuration files in Docker/OCI registries";
    homepage = "https://carvel.dev/imgpkg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benchand ];
    mainProgram = "imgpkg";
  };
})
