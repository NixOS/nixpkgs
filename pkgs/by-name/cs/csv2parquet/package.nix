{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "csv2parquet";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "domoritz";
    repo = "csv2parquet";
    rev = "v${version}";
    sha256 = "sha256-499DC0kLvvP5Oq2WYRb9BIppTdfm41u8hwrPU8b66Zw=";
  };

  cargoHash = "sha256-hZ4qdaR3dvcBBvZqfMQVk4hryhxfeAszv56WPNVhQiY=";

<<<<<<< HEAD
  meta = {
    description = "Convert CSV files to Apache Parquet";
    homepage = "https://github.com/domoritz/csv2parquet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ john-shaffer ];
=======
  meta = with lib; {
    description = "Convert CSV files to Apache Parquet";
    homepage = "https://github.com/domoritz/csv2parquet";
    license = licenses.mit;
    maintainers = with maintainers; [ john-shaffer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "csv2parquet";
  };
}
