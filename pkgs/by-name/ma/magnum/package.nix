{
  stdenv,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  cmake,
  corrade,
  libGL,
  libX11,
  openal,
  glfw,
  vulkan-loader,
  SDL2,

  # keep-sorted start case=no numeric=no block=yes
  buildDeprecated ? false,
  withAnyImageImporter ? true,
  withAnySceneImporter ? true,
  withAssimpImporter ? true,
  withAudio ? true,
  withGlfwApplication ? true,
  withGlxApplication ? true,
  withGlxContext ? true,
  withObjImporter ? true,
  withSDL2Application ? true,
  withStbImageImporter ? false,
  withWindowlessGlxApplication ? true,
  # keep-sorted end

  # failing
  #  Starting Magnum::Vk::Test::ShaderTest with 12 test cases...
  # magnum> Utility::Path::read(): can't open ShaderTestFiles/vert-frag.spv: error 2 (No such file or directory)
  # magnum>   FAIL [01] spirvPatchSwiftShaderConflictingMultiEntrypointLocations() at /build/source/src/Magnum/Vk/Test/ShaderTest.cpp:78
  # magnum>         Expression data failed.
  # magnum>  XFAIL [07] createInfoConstructNoInit() at /build/source/src/Magnum/Vk/Test/ShaderTest.cpp:223
  # magnum>         GCC 16+ misoptimizes and overwrites the value. info->sType and VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2 failed the comparison.
  withVulkan ? false,
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
  ++ lib.optional withGlfwApplication libX11
  ++ lib.optional withSDL2Application SDL2;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    # keep-sorted start case=no numeric=no block=yes
    (lib.cmakeBool "MAGNUM_BUILD_DEPRECATED" buildDeprecated)
    (lib.cmakeBool "MAGNUM_WITH_ANYIMAGEIMPORTER" withAnyImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_ANYSCENEIMPORTER" withAnySceneImporter)
    (lib.cmakeBool "MAGNUM_WITH_ASSIMPIMPORTER" withAssimpImporter)
    (lib.cmakeBool "MAGNUM_WITH_AUDIO" withAudio)
    (lib.cmakeBool "MAGNUM_WITH_GLFWAPPLICATION" withGlfwApplication)
    (lib.cmakeBool "MAGNUM_WITH_GLXAPPLICATION" withGlxApplication)
    (lib.cmakeBool "MAGNUM_WITH_GLXCONTEXT" withGlxContext)
    (lib.cmakeBool "MAGNUM_WITH_OBJIMPORTER" withObjImporter)
    (lib.cmakeBool "MAGNUM_WITH_SDL2APPLICATION" withGlfwApplication)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGEIMPORTER" withStbImageImporter)
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
        buildDeprecated
        withAnyImageImporter
        withAnySceneImporter
        withAssimpImporter
        withAudio
        withGlfwApplication
        withGlxApplication
        withGlxContext
        withObjImporter
        withSDL2Application
        withStbImageImporter
        withVulkan
        withWindowlessGlxApplication
        # keep-sorted end
        ;
    };

    withPlugins =
      extensions:
      symlinkJoin {
        name = "${finalAttrs.pname}-with-plugins-${finalAttrs.version}";
        paths = [
          finalAttrs.finalPackage
        ]
        ++ extensions;
      };
  };

  meta = with lib; {
    description = "Lightweight and modular C++11 graphics middleware for games and data visualization ";
    homepage = "https://github.com/msora/magnum";
    license = licenses.mit;
    maintainers = with maintainers; [ arntanguy ];
    platforms = platforms.all;
  };
})
