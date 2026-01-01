{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codefresh";
<<<<<<< HEAD
  version = "0.89.6";
=======
  version = "0.89.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "codefresh-io";
    repo = "cli";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-MlK+vWS2ylrWjnsNFP/FRr6YWXlpfE3Z6vMiNJvvdv0=";
=======
    hash = "sha256-Cf3I+w0rVsjsu+m+vE/pOcASYTmsRi0yAQVpJkYbzUU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
<<<<<<< HEAD
    hash = "sha256-CZFS13UqPiJtLFCkeSTp2GSJw+QY48ob4zgfaPm057U=";
=======
    hash = "sha256-wD3BmWjrFGkNqUhbo2TrWLwgo2o2MiQn7X3fyDYt5dw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    # codefresh needs to read a config file, this is faked out with a subshell
    command = "codefresh --cfconfig <(echo 'contexts:') version";
  };

  meta = {
    changelog = "https://github.com/codefresh-io/cli/releases/tag/v${finalAttrs.version}";
    description = "CLI tool to interact with Codefresh services";
    homepage = "https://github.com/codefresh-io/cli";
    license = lib.licenses.mit;
    mainProgram = "codefresh";
<<<<<<< HEAD
    maintainers = [
      lib.maintainers.burdzwastaken
      lib.maintainers.takac
    ];
=======
    maintainers = [ lib.maintainers.takac ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
