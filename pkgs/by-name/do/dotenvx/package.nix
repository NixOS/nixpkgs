{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
<<<<<<< HEAD
  version = "1.51.2";
=======
  version = "1.51.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-WafhFmph85r377VOFJBjXU8T/GbIrgXQ2RzcVb7GETw=";
  };

  npmDepsHash = "sha256-YVODU+0e9T/x9RkAEiHdQ1JxFlgwsrdyzx0ZIgmy9Fw=";
=======
    hash = "sha256-oXq3OfMPmfbBr5wfumiql8uX+tkCtJJ5W0CT6M3cBp8=";
  };

  npmDepsHash = "sha256-scRpNiBwZBtaYTpepNw+OsMS6Dy1uUq/hkH++cr2qRQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontNpmBuild = true;

  passthru.tests = {
    version = testers.testVersion {
      package = dotenvx;
      # access to the home directory
      command = "HOME=$TMPDIR dotenvx --version";
    };
  };

  meta = {
    description = "Better dotenv–from the creator of `dotenv";
    homepage = "https://github.com/dotenvx/dotenvx";
    changelog = "https://github.com/dotenvx/dotenvx/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "dotenvx";
  };
}
