{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-rendering${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-rendering";
    version = "10.0.2";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-rendering";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-xdIdwBcox+la4WtbSY5Z3VnWRzhuBsrcu6Rdd4hhNGI=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    cmakeFlags = [
      # Upstream CMake uses CMAKE_INSTALL_PREFIX/${CMAKE_INSTALL_LIBDIR} to build
      # the compiled-in plugin search path.  Nix sets CMAKE_INSTALL_LIBDIR to an
      # absolute store path, producing a doubled prefix.  Force it to be relative.
      (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "libexec")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
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
  }
)
