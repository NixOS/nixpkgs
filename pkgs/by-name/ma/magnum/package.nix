{
  stdenv,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  cmake,
  corrade,
  libGL,
  libx11,
  openal,
  glfw,
  vulkan-loader,
  SDL2,

  # The default options are chosen such that all plugins and extensions in magnum-examples
  # build against the default magnum derivation. These are not incredibly heavy dependencies,
  # so it should be light enough
  #
  # keep-sorted start case=no numeric=no block=yes
  withAnyImageConverter ? true,
  withAnyImageImporter ? true,
  withAnySceneImporter ? true,
  withAudio ? true,
  withGL ? true,
  withGlfwApplication ? true,
  withGlxApplication ? false,
  withGlxContext ? true,
  withObjImporter ? true,
  withSdl2Application ? true,
  withTargetGL ? true,
  withVulkan ? true,
  withWindowlessGlxApplication ? true,
  # keep-sorted end
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "magnum";
  version = "2020.06-unstable-2026-11-14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum";
    rev = "f0907f1c1d1247e6b9e2120ccf42971430edf5e0";
    hash = "sha256-8yGB3dgVdVl6qxDBN65midi2ojLvKv8d/MoU1U81RsE=";
  };

  nativeBuildInputs = [
    cmake
    corrade # Makes corrade-rc accessible during build
  ];
  propagatedBuildInputs = [
    corrade
    libGL
    openal
    glfw
  ]
  ++ lib.optional withVulkan vulkan-loader
  ++ lib.optional withGlfwApplication libx11
  ++ lib.optional withSdl2Application SDL2;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # (lib.cmakeBool "MAGNUM_BUILD_VK_TESTS" true)
    # keep-sorted start case=no numeric=no block=yes
    (lib.cmakeBool "MAGNUM_TARGET_GL" withTargetGL)
    (lib.cmakeBool "MAGNUM_WITH_ANYIMAGECONVERTER" withAnyImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_ANYIMAGEIMPORTER" withAnyImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_ANYSCENEIMPORTER" withAnySceneImporter)
    (lib.cmakeBool "MAGNUM_WITH_AUDIO" withAudio)
    (lib.cmakeBool "MAGNUM_WITH_GL" withGL)
    (lib.cmakeBool "MAGNUM_WITH_GLFWAPPLICATION" withGlfwApplication)
    (lib.cmakeBool "MAGNUM_WITH_GLXAPPLICATION" withGlxApplication)
    (lib.cmakeBool "MAGNUM_WITH_GLXCONTEXT" withGlxContext)
    (lib.cmakeBool "MAGNUM_WITH_OBJIMPORTER" withObjImporter)
    (lib.cmakeBool "MAGNUM_WITH_SDL2APPLICATION" withGlfwApplication)
    (lib.cmakeBool "MAGNUM_WITH_VK" withVulkan)
    (lib.cmakeBool "MAGNUM_WITH_WINDOWLESSGLXAPPLICATION" withWindowlessGlxApplication)
    # keep-sorted end
  ];

  doCheck = true;
  preCheck = ''
    # Needed for unit tests trying to use Alsa, which is not available in the sandbox
    export ALSOFT_DRIVERS=null
  '';

  passthru = {
    args = {
      inherit
        # keep-sorted start case=no numeric=no block=yes
        withAnyImageImporter
        withAnySceneImporter
        withAudio
        withGlfwApplication
        withGlxApplication
        withGlxContext
        withObjImporter
        withSdl2Application
        withVulkan
        withWindowlessGlxApplication
        # keep-sorted end
        ;
    };

    # The naive version of withPlugin with symlinkJoin does not propagate propagatedBuildInputs from 'extensions' derivations
    # (magnum-plugins, magnum-integration, magnum-extras).
    # So instead wrap magnum with plugins into a derivation and manually collect all propagatedBuildInputs
    withPlugins =
      extensions:
      let
        basePkg = finalAttrs.finalPackage;
        # Collect all unique propagated inputs from base package and plugins
        allPropagated = lib.unique (
          [ basePkg ]
          ++ extensions
          ++ (basePkg.propagatedBuildInputs or [ ])
          ++ lib.concatLists (map (p: p.propagatedBuildInputs or [ ]) extensions)
        );

        # Join the files together using symlinkJoin
        joined = symlinkJoin {
          name = "${finalAttrs.pname}-with-plugins-${finalAttrs.version}";
          paths = [ basePkg ] ++ extensions;
        };
      in
      # Wrap it in a lightweight stdenv.mkDerivation to guarantee propagatedBuildInputs are honored downstream
      stdenv.mkDerivation {
        name = "${joined.name}";
        src = null;
        dontUnpack = true;
        dontBuild = true;
        propagatedBuildInputs = allPropagated;
        installPhase = ''
          mkdir -p $out
          # Link everything from the joined store path into this derivation output
          cp -rs ${joined}/* $out/
          # Remove the symlinked/read-only nix-support brought over by cp -rs
          chmod -R +w $out/nix-support || true
          rm -rf $out/nix-support
          # Create a fresh, fully writable directory for Nix's fixup hook
          mkdir -p $out/nix-support
        '';
      };
  };

  meta = {
    description = "Lightweight and modular C++11 graphics middleware for games and data visualization ";
    homepage = "https://github.com/mosra/magnum";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arntanguy ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
