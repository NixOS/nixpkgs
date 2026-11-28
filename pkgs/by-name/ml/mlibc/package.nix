{
  lib,
  buildPackages,
  stdenvNoCC,
  stdenvNoLibc,
  fetchFromGitHub,
  fetchpatch,
  frigg,
  libsmarter,
  meson,
  ninja,
  pkg-config,
  linuxHeaders,
  headersOnly ? false,
}:
let
  stdenv = if headersOnly then stdenvNoCC else stdenvNoLibc;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlibc${lib.optionalString headersOnly "-headers"}";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "mlibc";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-e4YjosGDI2CWkGeih0HG69yPJa+sKAReTQ87lgzBTzg=";
  };

  patches = [
    # Merged upstream, drop in 7.1.0
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/pull/1861.patch";
      sha256 = "sha256-G0yPLYSkhq1sPAwIek3+tuqd/eJ12jmfkLin0f9asjE=";
    })
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/commit/eb4334a748b2f87f5bdc9405a959ab7ee1c16c0b.patch";
      sha256 = "sha256-gQqQGFB5HGx7t4c5/V5T3/ZR0wYTffIZmCWRGQ16Aew=";
    })
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/commit/ace4a3531a2a0c061de1cbdd83da690b5435251c.patch";
      sha256 = "sha256-8irpEFgU9gsQpOO/Two4g0zUmcOFcdcVyuThbhaisX0=";
    })
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/commit/68fb6901069533e90489283ac4490dc80a402780.patch";
      sha256 = "sha256-qw0bjEZtu6ufhdBGEY93GuogO1MeLsggxTKgWPNBCP0=";
    })
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/pull/1897.patch";
      sha256 = "sha256-7J6SQRyggEnhVx8WWFcfD9Wja3JpI9Kz2bKIUa4N0kE=";
    })
    (fetchpatch {
      url = "https://github.com/managarm/mlibc/pull/1914.patch";
      sha256 = "sha256-qDAkjjbxeafFEVJg2NmPrSSE9P/3LK8/ycWVrj7P/L8=";
    })
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

  buildInputs = lib.optionals (!headersOnly) [
    frigg
    libsmarter
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # patchelf adds entries it shouldn't to ld.so
  dontPatchELF = true;

  mesonBuildType = "release";
  mesonFlags = [
    "-Ddefault_library=both"
    "-Dlinux_kernel_headers=${linuxHeaders}/include"
    "-Dbuild_tests=false"
    "-Duse_freestnd_hdrs=disabled"
  ]
  ++ lib.optional headersOnly "-Dheaders_only=true";

  postInstall =
    lib.optionalString (!headersOnly) ''
      # This mlibc-gcc uses a specs file to wrap the host's one. It's a hack,
      # we don't use it.
      rm $out/bin/mlibc-gcc $out/lib/mlibc-gcc.specs
    ''
    + ''
      # some mlibc headers depend on linux headers
      # scsi/* is provided by mlibc
      find ${linuxHeaders}/include -mindepth 1 -maxdepth 1 ! -name 'scsi' -exec ln -s {} $dev/include \;

      # make sure $out exists
      mkdir -p $out
    '';

  postFixup = lib.optionalString (!headersOnly) ''
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
    broken = !stdenv.hostPlatform.isMlibc;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      lzcunt
    ];
  };
})
