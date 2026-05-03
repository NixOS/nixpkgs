{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "netfoil";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "tinfoil-factory";
    repo = "netfoil";
    tag = "v${version}";
    hash = "sha256-1JpnVaU17uxQu0O8R0kfl7lCE3YMd/XFmbq9KUMAKqY=";
  };

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  proxyVendor = true;

  vendorHash = "sha256-xtc1zCSLuez9POx/jEjre0uVmvWvCW0TpXPFVi2p+CY=";

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
