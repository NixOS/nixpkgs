{
  lib,
  buildGoModule,
  src,
  version,
  tilt-assets,
}:

buildGoModule rec {
  pname = "tilt";
  /*
    Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.
  */
  inherit src version;

  vendorHash = null;

  subPackages = [ "cmd/tilt" ];

  ldflags = [ "-X main.version=${version}" ];

  preBuild = ''
    mkdir -p pkg/assets/build
    cp -r ${tilt-assets}/* pkg/assets/build/
  '';

  meta = {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    mainProgram = "tilt";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anton-dessiatov ];
  };
}
