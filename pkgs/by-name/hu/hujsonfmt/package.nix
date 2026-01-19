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
  version = "0-unstable-2022-12-23";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "hujson";
    rev = "20486734a56a3455c47994bf4942974d6f9969a0";
    hash = "sha256-j2HRs5zZ0jTIqWIRhHheO9eaGzMMkNuKXuhboq9KpB4=";
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
