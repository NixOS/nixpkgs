{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "neoss";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "PabloLec";
    repo = "neoss";
    rev = version;
    hash = "sha256-1palorAZ58eHWAyQwfrz1RJGm8kwmR3UwvfI4bqstN0=";
  };

  npmDepsHash = "sha256-jmFhkV80D8SQcC3pRWg2FfQ0v3ur/gChAELpa66KpL8=";

  meta = with lib; {
    description = "User-friendly and detailed socket statistics with a Terminal UI";
    homepage = "https://github.com/PabloLec/neoss";
    license = licenses.bsd3;
    maintainers = with maintainers; [ snowflake ];
    mainProgram = "neoss";
  };
}
