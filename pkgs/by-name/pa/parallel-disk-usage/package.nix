{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-BeTidzXcCSe2IEXHAPpG9ZZJV/l/g09gtlZ9JNOuvsw=";
  };

  cargoHash = "sha256-rATv8Bg9g2vVyTWCjGPaBtvVgtqQCSs/RurvKmafG/8=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
