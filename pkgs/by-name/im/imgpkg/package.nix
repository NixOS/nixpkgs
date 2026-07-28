{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "imgpkg";
  version = "0.48.1";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "imgpkg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8T8wdpGJhqhVRk6BxrDX5Ci3PvxRDXzhUDKBqBg0gPk=";
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
