{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "8.3.2";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-mfIRQ8nkUbZ3Bugy3NAvOhcfzFY84J2kBUIUBcQ2/Qg=";
  };
}
