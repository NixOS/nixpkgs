{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-ci-ls";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
<<<<<<< HEAD
    hash = "sha256-Ly4pk+16RCr3r33VrYPTZGUXfUNd5IJHfA+uj7Ef3bk=";
  };

  cargoHash = "sha256-/w5inDL6ECs2Ce8Bdfr4sOKhGeFC0tE5SrW3aIXjHnA=";
=======
    hash = "sha256-ZpLkiTJP3pofDcXrQPdl5Vm6SKsp6DecwSfXWC9h2qI=";
  };

  cargoHash = "sha256-wDu89bhyR4a0U9KDF0iasdYrc1GUGlYH1y6D8+NKPy4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gitlab-ci-ls";
  };
}
