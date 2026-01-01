{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "managarr";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RBJ4Z5WTArQ/fG3Bv6wHAPJzRJNrIGTNphPYjV8Ocqc=";
  };

  cargoHash = "sha256-om4zGqh4bEgQZ+G2/MVGi9SCbopLdZ2K8hjIPIefiSQ=";
=======
    hash = "sha256-qIT+kgum+2D8X3rw20B1b2YQCgV/3CEvOpYQeoi55Ew=";
  };

  cargoHash = "sha256-7zFTR0NnN0Yd36aqdgiDzXt/0IAZC7fKtAz/mE89ubA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ perl ];

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.IncredibleLaser
      lib.maintainers.darkalex
      lib.maintainers.nindouja
    ];
    mainProgram = "managarr";
  };
}
