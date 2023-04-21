{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "28.3";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    sha256 = "UjVYVNAiPrTtFEDayIvISY1IO4ZjR6nEedPTKeM5e9Q=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  cargoSha256 = "TktvfO2GDc95IunC2YJhei+pihi2ctK0klnVZz/KlFw=";

  OPENSSL_NO_VENDOR = true;

  # Integration tests require root.
  cargoTestFlags = [ "--bins" ];

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
