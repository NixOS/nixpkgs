{
  applyPatches,
  fetchpatch2,
  fetchurl,
}:

applyPatches (final: {
  pname = "ceph-src";
  version = "20.2.0";

  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${final.version}.tar.gz";
    hash = "sha256-jeBk1pgx7zJzOVOfIzx47IJ/o1HEDO2amRbwtBdMZoU=";
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
    # allows ceph-mgr to run on python 3.12
    # See: https://github.com/ceph/ceph/pull/66794
    (fetchurl {
      name = "ceph-upstream-pyo3-workaround.patch";
      url = "https://github.com/ceph/ceph/pull/66794.diff?full_index=1";
      hash = "sha256-+OrG9JpMOfZwtzAPJkBrzt+8BGKKiNjQMMpkJSHpGFo=";
    })
    # fix prometheus metrics without orchestrator
    # See: https://github.com/ceph/ceph/pull/65906
    (fetchurl {
      name = "ceph-prometheus-fix.diff";
      url = "https://github.com/ceph/ceph/pull/65906.diff?full_index=1";
      hash = "sha256-3QEtrsVJYUFvq1eT16v8fsmjpZMqOZ8AAoH+Sv7YyYA=";
    })
    # fixes issues when python3 is not on the PATH
    # See: https://github.com/ceph/ceph/pull/67904
    ./patches/0001-mgr-python-interpreter.patch
  ];
})
