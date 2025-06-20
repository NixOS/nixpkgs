{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = version;
    hash = "sha256-yjNz51L/r1jqgeO0qhe8uR4Pn52acle+EmurZqVpWfI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-v+cJ1Hw4cae/8A1MpHbIfGRVamI58byqfBLNCKKAHWk=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
