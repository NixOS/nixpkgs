{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.3.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-7Nea5t2nhSl+Vhm4mVePIFSOlVEP08wFKZ8G3Onm564=";
  };
}
