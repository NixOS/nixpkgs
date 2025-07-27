{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = version;
    hash = "sha256-gzjNi7ujYe7OZKYyrYk1xqqo/k8yBJdIwRoNASm5Db4=";
  };

  cargoHash = "sha256-3U61AkCicX7VNh1bf0IHPH5YX7qAtp4PvWi8FRKoBQI=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
