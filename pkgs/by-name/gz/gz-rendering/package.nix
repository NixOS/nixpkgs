{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-math,
  gz-plugin,
  eigen,
  libGL,
  libx11,
  ogre-next-2,
  spdlog,
  vulkan-headers,
  vulkan-loader,
  python3,
  gtest,
  testers,
  nix-update-script,
}:
let
  version = "10.0.1";
  versionPrefix = "gz-rendering${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-rendering";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-rendering";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-gnNGe/yk+ucwPviaa6FusLD9Kp3SXKhnAChyNQhRzrM=";
  };

  patches = [
    # Mark GL3Plus plugin as optional on macOS where Metal is the primary
    # render system and GL3Plus may not be available.
    # TODO: Remove after update to > 10.0.1
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-rendering/commit/2e92a11bffd923e6b83a27a25cee9702cf6f34ef.patch?full_index=1";
      hash = "sha256-/PNGHDTuQoRl0WkWRrCjlITCzBzL9IjqSkSgrhFGeqA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    # Upstream CMake uses CMAKE_INSTALL_PREFIX/${CMAKE_INSTALL_LIBDIR} to build
    # the compiled-in plugin search path.  Nix sets CMAKE_INSTALL_LIBDIR to an
    # absolute store path, producing a doubled prefix.  Force it to be relative.
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  buildInputs = [
    gz-cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    vulkan-headers
    vulkan-loader
  ];

  propagatedBuildInputs = [
    gz-common
    gz-math
    gz-plugin
    eigen
    libGL
    ogre-next-2
    spdlog
  ];

  nativeCheckInputs = [ python3 ];

  checkInputs = [ gtest ];

  # Requires GPU/display server (unavailable in Nix sandbox)
  doCheck = false;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
    };
  };

  meta = {
    description = "C++ library for rendering designed for robot simulation";
    homepage = "https://github.com/gazebosim/gz-rendering";
    changelog = "https://github.com/gazebosim/gz-rendering/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-rendering" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
