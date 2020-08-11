{ lib, fetchFromGitHub, rustPlatform, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    sha256 = "h2aWWjycTm84TS89/vhqnAvwOqeeSDtvvCt+Is6I0eI=";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  cargoPatches = [ ./cargo-lock-vendor-fix.patch ];
  cargoSha256 = "fOIB+qVDqAAgQPW3bK2NfST24GzYJeRXgaMFXyNPcPQ=";

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ offline ];
    platforms = [ "x86_64-linux" ];
  };
}
