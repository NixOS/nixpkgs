{ stdenv
, callPackage
, python
, texinfo
, flex
, bison
, perl
, groff
, cmake
, git
}:
let
  sources = callPackage ./sources.nix {};
  src = sources.sources.native_client;
  patches = [
    ./0001-Do-not-write-REV-file.patch
    ./0002-Do-not-build-unsandboxed-runtime.patch
    ./0003-Make-pnacl-build.sh-work-with-host-compiler.patch
    ./0004-Do-not-get-GDB.patch
  ];
in stdenv.mkDerivation {
  name = "nacl-toolchain-${sources.revision}";

  buildInputs = [ python texinfo flex bison perl groff cmake git ];

  buildCommand = sources.copySources +
  ''
    cd native_client

    ${stdenv.lib.concatStringsSep "\n" (map (patch: "patch -p1 < ${patch}") patches)}

    env PNACL_CONCURRENCY=$NIX_BUILD_CORES \
    toolchain_build/toolchain_build_pnacl.py \
      --verbose \
      --clobber \
      --gcc \
      --no-use-cached-results \
      --no-use-remote-cache \
      --no-nacl-gcc \
      --build-sbtc

    mkdir $out

    build/package_version/package_version.py \
      --packages pnacl_newlib \
      --tar-dir toolchain_build/out/packages \
      --dest-dir $out \
      extract \
      --skip-missing

    build/package_version/package_version.py \
      --packages pnacl_translator \
      --tar-dir toolchain_build/out/packages \
      --dest-dir $out \
      extract \
      --skip-missing
  '';
}
