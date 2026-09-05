{
  lib,
  buildPackages,
  stdenvNoCC,
  stdenvNoLibc,
  fetchFromGitHub,
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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      lzcunt
    ];
  };
})
