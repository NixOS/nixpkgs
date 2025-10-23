{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  getopt,
  util-linuxMinimal,
  which,
  gperf,
  nix-update-script,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "libseccomp";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    hash = "sha256-g7YIUjLRWIw3ncm5yuR7s3QHzyYubnSZPGG6ctKnhNw=";
  };

  patches = [
    # Remove when version > 2.6.0
    # Fixes test failures on big-endian archs
    (fetchpatch {
      name = "0001-libseccomp-remove-fuzzer-from-test-62-sim-arch_transactions.patch";
      url = "https://github.com/seccomp/libseccomp/commit/2f0f3b0e9121720108431c5d054164016f476230.patch";
      hash = "sha256-AKAQyALJlLgxnS23OEoqfyDswp0kU2vmja5ohgvFojw=";
    })

    # Remove when version > 2.6.0
    # Fixes OOB reads & tests on musl
    (fetchpatch {
      name = "0002-libseccomp-fix-seccomp_export_bpf_mem-out-of-bounds-read.patch";
      url = "https://github.com/seccomp/libseccomp/commit/dd759e8c4f5685b526638fba9ec4fc24c37c9aec.patch";
      hash = "sha256-TdfQ5T8FrGE6+P24MIi9rKSC3fQu/Jlr4bsFiJd4yVY=";
    })
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
    "pythonsrc"
  ];

  nativeBuildInputs = [ gperf ];
  buildInputs = [ getopt ];

  postPatch = ''
    patchShebangs .
  '';

  nativeCheckInputs = [
    util-linuxMinimal
    which
  ];
  doCheck = !(stdenv.targetPlatform.useLLVM or false);

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  # Copy the python module code into a tarball that we can export and use as the
  # src input for buildPythonPackage calls
  postInstall = ''
    cp -R ./src/python/ tmp-pythonsrc/
    tar -zcf $pythonsrc --mtime="@$SOURCE_DATE_EPOCH" --sort=name --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (python3Packages) seccomp;
    };
  };

  meta = with lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    mainProgram = "scmp_sys_resolver";
    homepage = "https://github.com/seccomp/libseccomp";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    badPlatforms = [
      "alpha-linux"
      "m68k-linux"
      "microblaze-linux"
      "microblazeel-linux"
      "riscv32-linux"
      "sparc-linux"
      "sparc64-linux"
    ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
