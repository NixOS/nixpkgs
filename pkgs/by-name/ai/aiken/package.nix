{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
<<<<<<< HEAD
  version = "1.1.21";
=======
  version = "1.1.19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8Oq6Bem4mREHXsBC0FwBnU2MVmTh8b7KtJ/KrPDMqLU=";
  };

  cargoHash = "sha256-5TplKj7q8G1XX6o4d8Vlgf5eGXB8fpnvkl7TwVcuTw0=";
=======
    hash = "sha256-S3KIOlOz21ItWI+RoeHPYROIlMbKAoNi7hXwHHjHaJs=";
  };

  cargoHash = "sha256-RrcP23p3KVIGKiW1crDDn5eoowjX3nTPUWBYtT9qdz0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aciceri ];
    mainProgram = "aiken";
  };
}
