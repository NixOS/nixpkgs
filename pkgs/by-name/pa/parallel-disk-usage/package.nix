{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-nWn6T1vJ4UANuU5EL5Ws5qT+k8Wd3Cm0SOJEgAbsCvo=";
  };

  cargoHash = "sha256-69DwIDGX4b+l2ay+OH3gjHnCj43VXruzBklOkS6M0DY=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
