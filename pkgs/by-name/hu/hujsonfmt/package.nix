{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  inherit (lib) licenses maintainers;
in
buildGoModule {
  pname = "hujsonfmt";
  version = "0-unstable-2025-06-05";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "hujson";
    rev = "992244df8c5ad853c10f498549e0eab54e515d13";
    hash = "sha256-5lEvWiCxU+5oKbBon8EvBUON9WtxDausRVFU1+q2TZE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-cvoj85BNnm/ZX1UnXKU2HjvjQkRZ9uN3U0BnD3DmiTE=";

  subPackages = [ "cmd/hujsonfmt" ];

  meta = {
    homepage = "https://tailscale.com";
    description = "Automatic formatter for HuJSON / JSON With Comments and trailing Commas (JWCC)";
    license = licenses.bsd3;
    mainProgram = "hujsonfmt";
    maintainers = with maintainers; [ dan-theriault ];
  };
}
