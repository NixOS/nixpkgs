{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "netfoil";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tinfoil-factory";
    repo = "netfoil";
    tag = "v${version}";
    hash = "sha256-HWAw3CxuVOinYhcJS5KjkscFURSamsiu4oLNU+z16zc=";
  };

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  proxyVendor = true;

  vendorHash = "sha256-L+E6pLDi68TpXxzSwWlbwMLbnkJHvQY1kRwTtk6pWYM=";

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
