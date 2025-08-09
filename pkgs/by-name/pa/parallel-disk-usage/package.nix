{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = version;
    hash = "sha256-Xzc+1cPs84o58G7n8hEN9vtaz3bw3TrwodphK45Iq2g=";
  };

  cargoHash = "sha256-qSQpjYydpjVUP5AO2sPshP/HZzeVihwlJxyabml67js=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
