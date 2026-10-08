{
  rocksdb,
  fetchFromGitHub,
}:

rocksdb.overrideAttrs rec {
  version = "7.9.2";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    tag = "v${version}";
    hash = "sha256-5P7IqJ14EZzDkbjaBvbix04ceGGdlWBuVFH/5dpD5VM=";
  };
}
