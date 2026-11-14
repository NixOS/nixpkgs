{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "7.10.2";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-U2ReSrJwjAXUdRmwixC0DQXht/h/6rV8SOf5e2NozIs=";
  };
}
