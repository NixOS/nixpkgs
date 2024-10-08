{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    hash = "sha256-+QgbSpiDKPTVdSm0teEab1O6OJZKEDpC2ZIZ728e69Y=";
  };

  cargoHash = "sha256-lXYTZ3nvLrfEgo7AY/qSQYpXsyrdJuQQw43xREezNn0=";

  # Tests need the executable in target/debug/
  preCheck = ''
    cargo build
  '';

  meta = with lib; {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ samueltardieu ];
    mainProgram = "binsider";
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
}
