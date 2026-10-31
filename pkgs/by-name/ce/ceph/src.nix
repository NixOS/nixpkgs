{
  applyPatches,
  fetchpatch2,
  fetchurl,
}:

applyPatches (final: {
  pname = "ceph-src";
  version = "21.2.0";

  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${final.version}.tar.gz";
    hash = "sha256-gtPAJgkWG94TDHxBwzxfiztZGFzep355KbveLLxm44U=";
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
    # allows bin/dbstore-bin to compile without linker errors due to missing expat
    ./patches/0003-dbstore-expat.patch
    # `./autogen.sh` of the vendored qatlib and QATzip fails with `exec format error`
    # because the shebang is below the license header.
    # Fixed upstream; remove when this patch fails to apply.
    # See: https://tracker.ceph.com/issues/81385
    # See: https://github.com/ceph/ceph/pull/73061
    ./patches/0004-qat-autogen-shebang.patch
  ];
})
