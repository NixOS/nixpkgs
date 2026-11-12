{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "11.8.1";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-zjOo0H8/qA879Lcw5wHp2BZzOhl+/wYluxKD9RCfQ+0=";
  };
}
