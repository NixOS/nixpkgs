{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-Bo2fBOGuAur3dQtBdcbeDRBgp+bFpi86dZQjSuZpEc8=";
  };

  cargoHash = "sha256-V7j2dvu7Z3Xq8WGoFxl6DjO8sYU8+ZNC9V6qqdYIuQo=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [maintainers.peret];
    mainProgram = "pdu";
  };
}
