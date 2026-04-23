{
  stdenv,
  lib,
  # Break cycle by using self-contained toolchain for bootstrapping
  build2-bootstrap,
  fetchurl,
  fixDarwinDylibNames,
  libbutl,
  libpkgconf,
  buildPackages,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
}:
let
  inherit (build2-bootstrap.passthru) configSharedStatic;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "build2";
  version = "0.17.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  setupHook = build2-bootstrap.setupHook;

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/build2-${finalAttrs.version}.tar.gz";
    hash = "sha256-Kx5X/GV3GjFSbjo1mzteiHnnm4mr6+NAKIR/mEE+IdA=";
  };

  patches = [
    # Remove any build/host config entries which refer to nix store paths
    ./remove-config-store-paths.patch
  ]
  ++ build2-bootstrap.patches;

  strictDeps = true;
  nativeBuildInputs = [
    build2-bootstrap
  ];
  disallowedReferences = [
    build2-bootstrap
    libbutl.dev
    libpkgconf.dev
  ];
  buildInputs = [
    libbutl
    libpkgconf
  ];

  # Build2 uses @rpath on darwin
  # https://github.com/build2/build2/issues/166
  # N.B. this only adjusts the install_name after all libraries are installed;
  # packages containing multiple interdependent libraries may have
  # LC_LOAD_DYLIB entries containing @rpath, requiring manual fixup
  propagatedBuildInputs = lib.optionals stdenv.targetPlatform.isDarwin [
    fixDarwinDylibNames

    # Build2 needs to use lld on Darwin because it creates thin archives when it detects `llvm-ar`,
    # which ld64 does not support.
    (lib.getBin buildPackages.llvmPackages.lld)
  ];

  postPatch = ''
    patchShebangs --build tests/bash/testscript
  '';

  build2ConfigureFlags = [
    "config.bin.lib=${configSharedStatic enableShared enableStatic}"
    "config.cc.poptions+=-I${lib.getDev libpkgconf}/include/pkgconf"
    "config.build2.libpkgconf=true"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath "''${!outputLib}/lib" "''${!outputBin}/bin/b"
  '';

  postFixup = ''
    substituteInPlace $dev/nix-support/setup-hook \
      --subst-var-by isTargetDarwin '${toString stdenv.targetPlatform.isDarwin}'
  '';

  passthru = {
    bootstrap = build2-bootstrap;
    inherit configSharedStatic;
  };

  meta = {
    inherit (build2-bootstrap.meta)
      homepage
      license
      changelog
      platforms
      maintainers
      ;
    description = "Build2 build system";
    longDescription = ''
      build2 is an open source (MIT), cross-platform build toolchain
      that aims to approximate Rust Cargo's convenience for developing
      and packaging C/C++ projects while providing more depth and
      flexibility, especially in the build system.

      build2 is a hierarchy of tools consisting of a general-purpose
      build system, package manager (for package consumption), and
      project manager (for project development). It is primarily aimed
      at C/C++ projects as well as mixed-language projects involving
      one of these languages (see bash and rust modules, for example).
    '';
    mainProgram = "b";
  };
})
