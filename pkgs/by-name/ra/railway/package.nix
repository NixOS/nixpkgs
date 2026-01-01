{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "railway";
<<<<<<< HEAD
  version = "4.12.0";
=======
  version = "4.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ViafZYAQCEfNJZpJgWVHG55+Ylkl3xndqT+zuNUDF04=";
  };

  cargoHash = "sha256-CaB6sobEw+Z/R/zjGNonVhIiuX676P/4SA6nwoWWA7g=";
=======
    hash = "sha256-3MqMkef/oc6Fk2PHvdTMlH/lRU19Tru5uqs8yVThSdw=";
  };

  cargoHash = "sha256-JYsnrZsUrESOZQzVOkHLFDDtjDCzGva6mrFLSOiEUzw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

<<<<<<< HEAD
  env.OPENSSL_NO_VENDOR = 1;
=======
  OPENSSL_NO_VENDOR = 1;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
}
