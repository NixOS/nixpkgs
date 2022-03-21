{ lib
, stdenv
, symlinkJoin
, buildGoModule
, ipfs-migrator-unwrapped
}:

# This package contains all the individual migrations in the bin directory.
# This is used by fs-repo-migrations and could also be used by IPFS itself
# when starting it like this: ipfs daemon --migrate

let
  fs-repo-common = pname: version: buildGoModule {
    inherit pname version;
    inherit (ipfs-migrator-unwrapped) src;
    sourceRoot = "source/${pname}";
    vendorSha256 = null;
    doCheck = false;
    meta = ipfs-migrator-unwrapped.meta // {
      mainProgram = pname;
      description = "Individual migration for the filesystem repository of ipfs clients";
    };
  };

  # Concatenation of the latest repo version and the version of that migration
  version = "12.1.0.2";

  fs-repo-11-to-12 = fs-repo-common "fs-repo-11-to-12" "1.0.2";
  fs-repo-10-to-11 = fs-repo-common "fs-repo-10-to-11" "1.0.1";
  fs-repo-9-to-10  = fs-repo-common "fs-repo-9-to-10"  "1.0.1";
  fs-repo-8-to-9   = fs-repo-common "fs-repo-8-to-9"   "1.0.1";
  fs-repo-7-to-8   = fs-repo-common "fs-repo-7-to-8"   "1.0.1";
  fs-repo-6-to-7   = fs-repo-common "fs-repo-6-to-7"   "1.0.1";
  fs-repo-5-to-6   = fs-repo-common "fs-repo-5-to-6"   "1.0.1";
  fs-repo-4-to-5   = fs-repo-common "fs-repo-4-to-5"   "1.0.1";
  fs-repo-3-to-4   = fs-repo-common "fs-repo-3-to-4"   "1.0.1";
  fs-repo-2-to-3   = fs-repo-common "fs-repo-2-to-3"   "1.0.1";
  fs-repo-1-to-2   = fs-repo-common "fs-repo-1-to-2"   "1.0.1";
  fs-repo-0-to-1   = fs-repo-common "fs-repo-0-to-1"   "1.0.1";

  all-migrations = [
    fs-repo-11-to-12
    fs-repo-10-to-11
    fs-repo-9-to-10
    fs-repo-8-to-9
    fs-repo-7-to-8
  ] ++ lib.optional (!stdenv.isDarwin) # I didn't manage to fix this on macOS:
    fs-repo-6-to-7                     # gx/ipfs/QmSGRM5Udmy1jsFBr1Cawez7Lt7LZ3ZKA23GGVEsiEW6F3/eventfd/eventfd.go:27:32: undefined: syscall.SYS_EVENTFD2
  ++ [
    fs-repo-5-to-6
    fs-repo-4-to-5
    fs-repo-3-to-4
    fs-repo-2-to-3
    fs-repo-1-to-2
    fs-repo-0-to-1
  ];

in

symlinkJoin {
  name = "ipfs-migrator-all-fs-repo-migrations-${version}";
  paths = all-migrations;
}
