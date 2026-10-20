{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "6.23.3";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-SsDqhjdCdtIGNlsMj5kfiuS3zSGwcxi4KV71d95h7yk=";
  };
}
