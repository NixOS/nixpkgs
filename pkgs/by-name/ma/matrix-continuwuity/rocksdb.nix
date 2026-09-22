{
  stdenv,
  fetchFromGitea,
  rocksdb,
  rust-jemalloc-sys-unprefixed,
}:

(rocksdb.override {
  # rocksdb does not support prefixed jemalloc, which is required on darwin
  enableJemalloc = !stdenv.hostPlatform.isDarwin;
  jemalloc = rust-jemalloc-sys-unprefixed;
}).overrideAttrs
  (
    final: old: {
      version = "11.1.1";
      src = fetchFromGitea {
        domain = "forgejo.ellis.link";
        owner = "continuwuation";
        repo = "rocksdb";
        rev = "3756b2b905e13216d8b56bcc783d814e7b073aff";
        hash = "sha256-rSv4fr2bf9JJwdodgeuPCuceeh7k97KVxrAOC0wyPQY=";
      };

      patches = [ ];
    }
  )
