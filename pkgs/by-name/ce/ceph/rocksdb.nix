{
  rocksdb,
  fetchFromGitHub,
}:

rocksdb.overrideAttrs {
  version = "7.9.2";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    tag = "v7.9.2";
    hash = "sha256-5P7IqJ14EZzDkbjaBvbix04ceGGdlWBuVFH/5dpD5VM=";
  };
}
