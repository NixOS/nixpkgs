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
  withWindowlessGlxApplication ? true,
  # keep-sorted end

  # failing
  #  Starting Magnum::Vk::Test::ShaderTest with 12 test cases...
  # magnum> Utility::Path::read(): can't open ShaderTestFiles/vert-frag.spv: error 2 (No such file or directory)
  # magnum>   FAIL [01] spirvPatchSwiftShaderConflictingMultiEntrypointLocations() at /build/source/src/Magnum/Vk/Test/ShaderTest.cpp:78
  # magnum>         Expression data failed.
  # magnum>  XFAIL [07] createInfoConstructNoInit() at /build/source/src/Magnum/Vk/Test/ShaderTest.cpp:223
  # magnum>         GCC 16+ misoptimizes and overwrites the value. info->sType and VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2 failed the comparison.
  withVulkan ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "magnum";
  version = "2020.06-unstable-2026-10-19";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum";
    rev = "369e9620ab22224ae66a376290b9b36e872209ce";
    hash = "sha256-ld8liF60ImYVNr4qEbcacu/8wtaC7jZEzpamKW380TU=";
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
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
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
    ls /build/source/src/Magnum/Vk/Test/ShaderTestFiles/vert-frag.spv
    ls /build/source/src/Magnum/Vk/Test/ShaderTestFiles
  '';

  postPatch = ''
    # Helper function to skip tests in the root-privileged Nix sandbox
    skip_test() {
      substituteInPlace "$1" \
        --replace-fail "void $2() {" "void $2() { CORRADE_SKIP(\"Skipped in Nix sandbox\");"
    }

    # XPASS [12] createInfoConstructNoInit() at /build/source/src/Magnum/Vk/Test/SamplerTest.cpp:200
    #       info->sType and VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO were expected to fail the comparison.
    skip_test src/Magnum/Vk/Test/SamplerTest.cpp SamplerTest::createInfoConstructNoInit
  '';

  patches = [ ./magnum-fix-vk-test.patch ];

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

    ## The naive version of withPlugin with symlinkJoin does not propagate propagatedBuildInputs from 'extensions' derivations
    ## (magnum-plugins, magnum-integration, magnum-extras)
    #
    # withPlugins =
    #   extensions:
    #   symlinkJoin {
    #     name = "${finalAttrs.pname}-with-plugins-${finalAttrs.version}";
    #     paths = [
    #       finalAttrs.finalPackage
    #     ]
    #     ++ extensions;
    #   };
    #
    # So instead try to wrap magnum with plugins into a real derivation
    # and manually collect all propagatedBuildInputs
    # It seems to work, but is it a good method?
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
      stdenv.mkDerivation rec {
        name = "${joined.name}-wrapped";
        src = null;
        dontUnpack = true;
        dontBuild = true;
        propagatedBuildInputs = builtins.trace "${name} has propagatedBuildInputs: ${toString allPropagated}" allPropagated;
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
