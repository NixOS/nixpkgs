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
  swig,
  libyaml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtc";
  version = "1.7.2";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-v${finalAttrs.version}.tar.gz";
    hash = "sha256-KZCzrvdWd6zfQHppjyp4XzqNCfH2UnuRneu+BNIRVAY=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/dgibson/dtc/pull/141
      url = "https://github.com/dgibson/dtc/commit/56a7d0cb3be5f2f7604bc42299e24d13a39c72d8.patch";
      hash = "sha256-GmAyk/K2OolH/Z8SsgwCcq3/GOlFuSpnVPr7jsy8Cs0=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  nativeBuildInputs =
    [
      meson
      ninja
      flex
      bison
      pkg-config
      which
    ]
    ++ lib.optionals pythonSupport [
      python
      python.pkgs.setuptools-scm
      swig
    ];

  buildInputs = [ libyaml ];

  postPatch = ''
    patchShebangs setup.py
  '';

  # Required for installation of Python library and is innocuous otherwise.
  env.DESTDIR = "/";

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonBool "static-build" stdenv.hostPlatform.isStatic)
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

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "dtc";
  };
})
