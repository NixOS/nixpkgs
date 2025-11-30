{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-4F17DArBV3kKQJi24pwD+JE7W9AuAQrxJcU1YTj93os=";
  };

  cargoHash = "sha256-wvvtlhlgwZylE6tucVcmsGbos6h5Nc8ZfP8zlkcIoqw=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = with lib; {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
