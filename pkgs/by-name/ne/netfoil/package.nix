{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "netfoil";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tinfoil-factory";
    repo = "netfoil";
    tag = "v${version}";
    hash = "sha256-EpWmOihf+zFWFLHjH+/LE+ydai0AJZk9peZQw++9SH8=";
  };

  env.CGO_ENABLED = 0;

  proxyVendor = true;

  vendorHash = "sha256-KzIb7ba6l3USJzObrWRO+9u/YdGvM4fxZ2fZesetT9o=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Minimal, filtering, DNS proxy";
    homepage = "https://github.com/tinfoil-factory/netfoil";
    license = licenses.asl20;
    maintainers = with maintainers; [
      sgo
      marcusramberg
    ];
    mainProgram = "netfoil";
  };
}
