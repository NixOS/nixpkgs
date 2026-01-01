{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cordova";
<<<<<<< HEAD
  version = "13.0.0";
=======
  version = "12.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cordova-cli";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-GJTrFGrUzSQ/Hsphn0zkjFYQkFw5i7ntc8HqIYdOYL4=";
  };

  npmDepsHash = "sha256-y81NdwF+RU20jmCi+Fou3Vc9ivt1x8JOj7biAsuSYDg=";
=======
    hash = "sha256-fEV7NlRcRpyeRplsdXHI2U4/89DsvKQpVwHD5juiNPo=";
  };

  npmDepsHash = "sha256-ZMxZiwCgqzOBwDXeTfIEwqFVdM9ysWeE5AbX7rUdwIc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontNpmBuild = true;

  meta = {
    description = "Build native mobile applications using HTML, CSS and JavaScript";
    homepage = "https://github.com/apache/cordova-cli";
    license = lib.licenses.asl20;
    mainProgram = "cordova";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
