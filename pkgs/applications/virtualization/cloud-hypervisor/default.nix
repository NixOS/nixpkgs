{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "18.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k9gclkba2bhmyqhyigjgfgcnqpg16v3yczhh08ljxmbrsbs02ig";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  cargoSha256 = "086ldzb1rbbrzjbklay4nvhc18ipyxi9gnp56f06393zvfbhc5dl";

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
