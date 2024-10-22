{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "nix-store-gcs-proxy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nix-store-gcs-proxy";
    rev = "v${version}";
    hash = "sha256-ljJrBNSGPZ9cV/+XcMNfMLT5le7tvtf/O42Tfou5BCA=";
  };

  vendorHash = "sha256-Bm3yFzm2LXOPYWQDk/UBusV0lPfc/BCKIb3pPlWgDFo=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "HTTP nix store that proxies requests to Google Storage";
    mainProgram = "nix-store-gcs-proxy";
    homepage = "https://github.com/tweag/nix-store-gcs-proxy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}

