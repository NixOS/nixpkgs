{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rnr";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ismaelgv";
    repo = "rnr";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-vuYFh7k7dNCOnB5jqP8MIBIWFOVxRmv0+qvCXkJchtA=";
  };

  cargoHash = "sha256-2YvpO8K5Y8Ul2k0sJXWMgrHnGY8e1sEcIZNWIEpKfqs=";
=======
    sha256 = "sha256-uuM8zh0wFSsySedXmdm8WGGR4HmUc5TCZ6socdztrZI=";
  };

  cargoHash = "sha256-lXo3BECHpiNMRMgd4XZy+b8QHbE0TZ5/P4cz+SgwqsY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Command-line tool to batch rename files and directories";
    mainProgram = "rnr";
    homepage = "https://github.com/ismaelgv/rnr";
    changelog = "https://github.com/ismaelgv/rnr/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
