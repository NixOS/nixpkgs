{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gklib,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metis";
  version = "5.2.1";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "METIS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eddLR6DvZ+2LeR0DkknN6zzRvnW+hLN2qeI+ETUPcac=";
  };

  patches = [
    # fix gklib link error
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/metis/files/metis-5.2.1-add-gklib-as-required.patch?id=c78ecbd3fdf9b33e307023baf0de12c4448dd283";
      hash = "sha256-uoXMi6pMs5VrzUmjsLlQYFLob1A8NAt9CbFi8qhQXVQ=";
    })
    # cmake 4 compatibility
    (fetchpatch {
      name = "metis-cmake-minimum-required-bump.patch";
      url = "https://github.com/KarypisLab/METIS/commit/350931887dfc00c2e3cb7551c5abf30e0297126a.patch";
      hash = "sha256-vX1GSZOLDxO9IIAQmNa9ADreEWSHCU9eF9L8qiSHye8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gklib ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  preConfigure = ''
    make config
  '';

  cmakeFlags = [
    (lib.cmakeBool "OPENMP" true)
    (lib.cmakeBool "SHARED" (!stdenv.hostPlatform.isStatic))
  ];

  # Upstream's own CMakeLists.txt never exports a CMake package-config file
  # (just a bare `install(TARGETS metis ...)`, no `install(EXPORT ...)` and
  # no Config.cmake of any kind), so `find_package(METIS)` can't find this
  # package from any consumer. Write one by hand describing the library and
  # headers this derivation already installs, as a `METIS::METIS` imported
  # target (the name/case consumers like symforce look for).
  postInstall =
    let
      libSuffix =
        if !stdenv.hostPlatform.isStatic then
          stdenv.hostPlatform.extensions.sharedLibrary
        else
          stdenv.hostPlatform.extensions.staticLibrary;
    in
    ''
      mkdir -p $out/lib/cmake/metis

      substitute ${./cmake/MetisConfig.cmake.in} $out/lib/cmake/metis/metis-config.cmake \
        --subst-var out \
        --subst-var-by libSuffix "${libSuffix}"

      substitute ${./cmake/MetisConfigVersion.cmake.in} $out/lib/cmake/metis/metis-config-version.cmake \
        --subst-var-by version "${finalAttrs.version}"
    '';

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "https://github.com/KarypisLab/METIS";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      qbisi
      pandapip1
    ];
    platforms = lib.platforms.all;
  };
})
