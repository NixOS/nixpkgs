{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  fetchpatch,
  nixosTests,
  gitUpdater,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "kexec-tools";
  version = "2.0.31";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${pname}-${version}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${pname}-${version}.tar.xz"
    ];
    sha256 = "sha256-io81Ddxm4ckFo6tSWn6bqWyB4E5w72k5ewFVtnuSLDE=";
  };

  patches =
    lib.optionals (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isAbiElfv2) [
      # Use ELFv2 ABI on ppc64be
      (fetchpatch {
        url = "https://raw.githubusercontent.com/void-linux/void-packages/6c1192cbf166698932030c2e3de71db1885a572d/srcpkgs/kexec-tools/patches/ppc64-elfv2.patch";
        sha256 = "19wzfwb0azm932v0vhywv4221818qmlmvdfwpvvpfyw4hjsc2s1l";
      })
    ]
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) ./fix-purgatory-llvm-libunwind.patch;

  hardeningDisable = [
    "format"
    "pic"
    "relro"
    "pie"
  ];

  # Prevent kexec-tools from using uname to detect target, which is wrong in
  # cases like compiling for aarch32 on aarch64
  configurePlatforms = [
    "build"
    "host"
  ];
  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [
    zlib
    zstd
  ];

  enableParallelBuilding = true;

  passthru = {
    tests.kexec = nixosTests.kexec;
    updateScript = gitUpdater {
      url = "https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git";
      rev-prefix = "v";
      allowedVersions = "^([0-9]+\\.){2}[0-9]+$";
    };
  };

  meta = with lib; {
    homepage = "http://horms.net/projects/kexec/kexec-tools";
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    badPlatforms = [
      "microblaze-linux"
      "microblazeel-linux"
      "riscv64-linux"
      "riscv32-linux"
      "sparc-linux"
      "sparc64-linux"
    ];
    license = licenses.gpl2Only;
    mainProgram = "kexec";
  };
}
