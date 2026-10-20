{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "8.11.4";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ZrU7G3xeimF3H2LRGBDHOq936u5pH/3nGecM4XEoWc8=";
  };
}
