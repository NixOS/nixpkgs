{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "efmt";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = version;
    hash = "sha256-l+DiOMUTEF6btsgkfgDtY45fH6GyqKBqHjuTfCF/ybA=";
  };

  cargoHash = "sha256-NJ49DqJW0qgM1dPOzlwMP9+JEfa1/YxvgMm4WmJ0mFA=";

  meta = {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
}
