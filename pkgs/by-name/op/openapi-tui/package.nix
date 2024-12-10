{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-flxQ5+nLacQAkrxJafw9D3iXYTFpHcmTshEySmFJ0Cc=";
  };

  cargoHash = "sha256-vfEDbUrIXc498QnMJJlMGyTUDvlHgquB5GpWTe7yCvM=";

  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "openapi-tui";
  };
}
