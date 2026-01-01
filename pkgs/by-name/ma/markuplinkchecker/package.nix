{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
let
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
rustPlatform.buildRustPackage {
  pname = "markuplinkchecker";
  inherit version;

  src = fetchFromGitHub {
    owner = "becheran";
    repo = "mlc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6v4tRCtoABbb0bwOagEGHk2QoUs3u/AnME5g7vhbkI4=";
  };

  cargoHash = "sha256-W4aOrKnRDAvHC4c+7e/XYSOgB/wFExqQhimaPJNiJk8=";
=======
    hash = "sha256-Bj1Yf+lrKwMvYnE/YVb+KC8tZtRr2OkWoYxQChLINyY=";
  };

  cargoHash = "sha256-r3LGWJ5RsvWRXNVXWIM83quC3AT8T+WDfSJnD3sVoOM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false; # tests require an internet connection

  meta = {
    description = "Check for broken links in markup files";
    homepage = "https://github.com/becheran/mlc";
    changelog = "https://github.com/becheran/mlc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anas
    ];
    mainProgram = "mlc";
  };
}
