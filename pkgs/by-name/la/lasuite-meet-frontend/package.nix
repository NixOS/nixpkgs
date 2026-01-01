{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "lasuite-meet-frontend";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.1.42";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "meet";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QtaP0b8Aj//tCS6uo4NJcK+IjyrSBTOZ+/ijG3T3ePE=";
=======
    hash = "sha256-STb4JCEoKgzokIA5mWFqJkFH9mtdnIp8NcopLWYSbwQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "source/src/frontend";

  npmDeps = fetchNpmDeps {
    inherit version src;
    sourceRoot = "source/src/frontend";
<<<<<<< HEAD
    hash = "sha256-aAIsdEmPbRhKFyN3O/zmO5hkhAXWbEMnr6i/r2sLrjU=";
=======
    hash = "sha256-SfAcGty6fT56eO7K3ZX87PiLiNlthl9UW3uAJmKM+lU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildPhase = ''
    runHook preBuild

    npm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Open source alternative to Google Meet and Zoom powered by LiveKit: HD video calls, screen sharing, and chat features. Built with Django and React";
    homepage = "https://github.com/suitenumerique/meet";
    changelog = "https://github.com/suitenumerique/meet/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
