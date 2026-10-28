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
    # revert the upstream change to the way the directory for systemd units is located
    # The new way seemingly cannot be overridden, and resolves to the location that *systemd* places its units.
    # With Nix guarding the access to /nix/store, this fails.
    # See: https://github.com/ceph/ceph/pull/43993
    (fetchpatch2 {
      name = "ceph-systemd-unit-dir.patch";
      url = "https://github.com/ceph/ceph/pull/43993.diff?full_index=1";
      hash = "sha256-00jW3Mp9q/Z1/83Dpu2Q7HJqeDQZPZCV8AsNznhUigw=";
      revert = true;
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
  ];
})
