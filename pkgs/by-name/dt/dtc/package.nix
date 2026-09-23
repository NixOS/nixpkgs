{
  stdenv,
  lib,
  fetchpatch2,
  fetchzip,
  meson,
  ninja,
  flex,
  bison,
  pkg-config,
  which,
  pythonSupport ? false,
  python ? null,
  replaceVars,
  swig,
  libyaml,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtc";
  version = "1.8.1";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-v${finalAttrs.version}.tar.gz";
    hash = "sha256-l32ZGygimwSB2xmwQEvS+C2c5n86OMH92jQZ/tPI+YI=";
  };

  patches = [
    # These 4 patches fix build failures on x86_64-linux for tests/dumptrees by replacing it.
    (fetchpatch2 {
      url = "https://github.com/dgibson/dtc/commit/9b53b9a4c2f953a37d8f68d72f5910b20cf5aee0.patch?full_index=1";
      hash = "sha256-HHX3zg1uwD3ZFHbHcANX85gNDpeEMVbkG7zMhyc/87k=";
    })
    (fetchpatch2 {
      url = "https://github.com/dgibson/dtc/commit/f116f4800edce6cd58f680a36fbaed656018d528.patch?full_index=1";
      hash = "sha256-XcLzfruD3DGs4girNxsqrhBW3Ct/+vAltn8OzIRyU6w=";
    })
    (fetchpatch2 {
      url = "https://github.com/dgibson/dtc/commit/4df9ca4c8ddb83c40900bf13916b42914a25caf4.patch?full_index=1";
      hash = "sha256-ap3D2DxHxLYOSJPhWAUP/nooi/n2/wLc65NfbjlYl2M=";
    })
    (fetchpatch2 {
      url = "https://github.com/dgibson/dtc/commit/214372a27398121f8266cf9bb9592561508c4c0f.patch?full_index=1";
      hash = "sha256-Fk0dA1J14NsIfd5qSknOMkB769TEwvWem8e+uEleM84=";
    })
  ]
  ++ lib.optionals pythonSupport [
    # Make Meson use our Python version, not the one it was built with itself
    (replaceVars ./python-path.patch {
      python_bin = lib.getExe python;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    flex
    bison
    pkg-config
  ]
  ++ lib.optionals pythonSupport [
    python
    swig
  ];

  buildInputs = [ libyaml ];

  postPatch = ''
    # Align the name with pypi
    substituteInPlace pyproject.toml --replace-fail "name = 'libfdt'" "name = 'pylibfdt'"
  '';

  # Required for installation of Python library and is innocuous otherwise.
  env.DESTDIR = "/";
  # glibc 2.43 C23 const-preserving strchr/strstr macros
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck =
    # Checks are broken on aarch64 darwin
    # https://github.com/NixOS/nixpkgs/pull/118700#issuecomment-885892436
    !stdenv.hostPlatform.isDarwin
    &&
      # Checks are broken when building statically on x86_64 linux with musl
      # One of the test tries to build a shared library and this causes the linker:
      # x86_64-unknown-linux-musl-ld: /nix/store/h9gcvnp90mpniyx2v0d0p3s06hkx1v2p-x86_64-unknown-linux-musl-gcc-13.3.0/lib/gcc/x86_64-unknown-linux-musl/13.3.0/crtbeginT.o: relocation R_X86_64_32 against hidden symbol `__TMC_END__' can not be used when making a shared object
      # x86_64-unknown-linux-musl-ld: failed to set dynamic section sizes: bad value
      !stdenv.hostPlatform.isStatic
    &&

      # we must explicitly disable this here so that mesonFlags receives
      # `-Dtests=disabled`; without it meson will attempt to run
      # hostPlatform binaries during the configurePhase.
      (with stdenv; buildPlatform.canExecute hostPlatform);

  passthru.updateScript = gitUpdater {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = lib.licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "dtc";
  };
})
