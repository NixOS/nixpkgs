{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.2.3";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-uMMmRP3T9KlF+S0xDk2rY2bqEjjM8zWJVRbegth4pdw=";
  };
}
