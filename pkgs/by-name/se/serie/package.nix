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
<<<<<<< HEAD
  version = "0.5.7";
=======
  version = "0.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JWpqF19rZIw4GyKAzoGYsuCEDJOLDRiHRFJBsguISZ0=";
  };

  cargoHash = "sha256-0pJDz6R/3EJl7K+cuy9ftngvOig/DO52cyUgkdnWa10=";
=======
    hash = "sha256-4F17DArBV3kKQJi24pwD+JE7W9AuAQrxJcU1YTj93os=";
  };

  cargoHash = "sha256-wvvtlhlgwZylE6tucVcmsGbos6h5Nc8ZfP8zlkcIoqw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

<<<<<<< HEAD
  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
=======
  meta = with lib; {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "serie";
  };
}
