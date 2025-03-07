{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "evebox";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "jasonish";
    repo = "evebox";
    rev = version;
    hash = "sha256-djL5cdudJNPAWLMQPS2Dkcc9H/gouOuu8evcBDdY9wA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsqlite3-sys-0.25.2" = "sha256-+c7ong6ca4WkEHl7ynCNn3WW68jF3pSYbllRsaNFGLc=";
      "suricatax-rule-parser-0.1.0" = "sha256-upWgOKSAuj0pYGTeYKANzwutoF/m4AQ7MkzGYXmPbEo=";
    };
  };

  meta = {
    description = "Web Based Event Viewer (GUI) for Suricata EVE Events in Elastic Search";
    homepage = "https://evebox.org/";
    changelog = "https://github.com/jasonish/evebox/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
    broken = stdenv.isDarwin;
  };
}
