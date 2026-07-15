{ lib, pkgs }:

# the README.md in the same directory contains further information on why this requires a scope
lib.makeScope pkgs.newScope (self: {
  ceph-rocksdb = self.callPackage ./rocksdb.nix { };

  # Ceph's `s3select` code needs `arrow/util/span.h`, which `arrow-cpp` removed
  # in 24.0.0. We vendor the last `arrow-cpp` version that still ships it.
  # See: https://github.com/NixOS/nixpkgs/issues/542206
  # Should be removed when Ceph supports arrow-cpp >= 24.
  ceph-arrow-cpp = self.callPackage ./arrow-cpp.nix { };

  # to get an idea which Python versions are supported by Ceph, see upstream `do_cmake.sh` (see `PYBUILD=` variable)
  ceph-python = self.callPackage ({ python312 }: python312) { };
  ceph-python-common = self.callPackage ./python-common.nix { };
  ceph-python-env = self.callPackage ./python-env.nix { };

  # Note when trying to upgrade boost:
  # * When upgrading Ceph, it's recommended to check which boost version Ceph uses on Fedora,
  #   and default to that.
  # * The version that Ceph downloads if `-DWITH_SYSTEM_BOOST:BOOL=ON` is not given
  #   is declared in `cmake/modules/BuildBoost.cmake` line `set(boost_version ...)`.
  ceph-boost = self.callPackage (
    { boost187, ceph-python }:
    boost187.override {
      enablePython = true;
      python = ceph-python;
    }
  ) { };

  # not actually a derivation, just a DRY helper
  ceph-meta = self.callPackage ./meta.nix { };

  # patched source to build all derivations from
  ceph-src = self.callPackage ./src.nix { };

  ceph = self.callPackage ./ceph.nix { };
})
