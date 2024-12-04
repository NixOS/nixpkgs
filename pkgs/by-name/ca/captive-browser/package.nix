{ lib, fetchFromGitHub, buildGoModule, fetchpatch }:

buildGoModule rec {
  pname = "captive-browser";
  version = "unstable-2021-08-01";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "captive-browser";
    rev = "9c707dc32afc6e4146e19b43a3406329c64b6f3c";
    sha256 = "sha256-65lPo5tpE0M/VyyvlzlcVSuHX4AhhVuqK0UF4BIAH/Y=";
  };

  vendorHash = "sha256-2MFdQ2GIDAdLPuwAiGPO9wU3mm2BDXdyTwoVA1xVlcQ=";
  deleteVendor = true;

  patches = [
    # Add go modules support
    (fetchpatch {
      url = "https://github.com/FiloSottile/captive-browser/commit/ef50837778ef4eaf38b19887e79c8b6fa830c342.patch";
      hash = "sha256-w+jDFeO94pMu4ir+G5CzqYlXxYOm9+YfyzbU3sbTyiY=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Dedicated Chrome instance to log into captive portals without messing with DNS settings";
    homepage = "https://blog.filippo.io/captive-browser";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
