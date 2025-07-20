{
  lib,
  buildPackages,
  stdenvNoLibc,
  fetchFromGitHub,
  freestnd-c-hdrs,
  freestnd-cxx-hdrs,
  frigg,
  meson,
  ninja,
  pkg-config,
  linuxHeaders,
}:
stdenvNoLibc.mkDerivation {
  pname = "mlibc";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "mlibc";
    rev = "f5f6bae6668a8db658563ba7ef6a95cecc2d758d";
    sha256 = "sha256-L8ghPFN9jNfXbEcv8Hr4zYgGDeXzJHINzhvV0XT87Bc=";
  };

  patches = [
    # Fixes a common build failure in nixpkgs.
    ./pr-1280-parse-tz.patch
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    # Meson needs to be in depsBuildBuild so that it doesn't cause a infinite
    # recursion through python3.
    meson
  ];

  nativeBuildInputs = [
    ninja
    pkg-config
  ];

  buildInputs = [
    # freestnd-*-hdrs are not required when building with a linux-mlibc
    # compiler, but currently, we need the freestanding headers to bootstrap.
    # Alternatively, we could install headers only and bootstrap a linux-mlibc
    # compiler with those headers, then compile with the linux-mlibc compiler.
    freestnd-c-hdrs
    freestnd-cxx-hdrs
    frigg
  ];

  # patchelf adds entries it shouldn't to ld.so
  dontPatchELF = true;

  mesonBuildType = "release";
  mesonFlags = [
    "-Ddefault_library=both"
    "-Dlinux_kernel_headers=${linuxHeaders}/include"
    "-Dbuild_tests=false"
  ];

  postInstall = ''
    # This mlibc-gcc uses a specs file to wrap the host's one. It's a hack,
    # we don't use it.
    rm $out/bin/mlibc-gcc $out/lib/mlibc-gcc.specs

    # some mlibc headers depend on linux headers
    # scsi/* is provided by mlibc
    find ${linuxHeaders}/include -maxdepth 1 ! -name 'scsi' -exec ln -s {} $dev/include \;
  '';

  postFixup = ''
    # The dynamic loader should never have a RPATH entry, let's remove it.
    # Normally NIX_DONT_SET_RPATH would be used but it breaks meson's sanity
    # checks, so we're doing it manually.
    if [ -f $out/lib/ld.so ]; then
      patchelf --remove-rpath $out/lib/ld.so
    fi
  '';

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Portable C standard library";
    homepage = "https://github.com/managarm/mlibc";
    platforms = [
      # These are the only platforms supported by both mlibc and nixpkgs
      "aarch64-linux"
      "i686-linux"
      "loongarch64-linux"
      "m68k-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      lzcunt
    ];
  };
}
