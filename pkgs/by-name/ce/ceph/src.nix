{
  applyPatches,
  fetchpatch2,
  fetchurl,
}:

applyPatches (final: {
  pname = "ceph-src";
  version = "20.2.2";

  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${final.version}.tar.gz";
    hash = "sha256-G76ZcCdadt4KP7Ry0yzqPrbi1ydZlrcZb2IhGd2Fd1M=";
  };

  patches = [
    # required to be able to compile s3select against nixpkgs' arrow-cpp
    # See: https://github.com/ceph/s3select/pull/169
    (fetchpatch2 {
      name = "ceph-s3select-arrow-cpp-20.patch";
      url = "https://github.com/ceph/s3select/pull/169.diff?full_index=1";
      extraPrefix = "src/s3select/";
      stripLen = 1;
      hash = "sha256-0jn5X4jIdluCufFXWHeO6skMz6XQpliHkC1tPLK6dbk=";
    })
    # arrow-cpp 24 dropped the `arrow/util/span.h` header and switched its
    # parquet encryption API from `arrow::util::span` to `std::span`.
    # Must be applied on top of the s3select patch above, which introduces the
    # vendored headers this touches.
    ./patches/0002-s3select-std-span.patch
    # fixes issues when python3 is not on the PATH
    # See: https://github.com/ceph/ceph/pull/67904
    ./patches/0001-mgr-python-interpreter.patch
  ];
})
