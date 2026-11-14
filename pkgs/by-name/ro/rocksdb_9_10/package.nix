{ rocksdb, fetchFromGitHub }:

rocksdb.overrideAttrs rec {
  pname = "rocksdb";
  version = "9.10.0";
  src = fetchFromGitHub {
    owner = "meta";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-G+DlQwEUyd7JOCjS1Hg1cKWmA/qAiK8UpUIKcP+riGQ=";
  };
}
