{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "imgpkg";
  version = "0.44.2";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "imgpkg";
    rev = "v${version}";
    hash = "sha256-UZhmuSUqm8EPCSc0CONgpISINgMJh3uNUx0v52eQNIc=";
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
