{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "phantun";
  version = "0.7.0-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "dndx";
    repo = "phantun";
    rev = "14f831c02b396c757f44a016edae2f4124f52035";
    hash = "sha256-dYj+X57+jwqOkog6qC0FrDqFd2VrbaJci2HiAVfn8+c=";
  };

  cargoHash = "sha256-l5VoSJNuoGQ/NPZfRIB1KYJ5dkIUXH890EAcM8DZqa0=";
  useFetchCargoVendor = true;

  meta = {
    description = "Transforms UDP stream into (fake) TCP streams that can go through Layer 3 & Layer 4 (NAPT) firewalls/NATs";
    homepage = "https://github.com/dndx/phantun";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oluceps ];
  };
}
