{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  corrade,
  magnum,
  magnum-plugins,
  magnum-extras,
  magnum-integration,
  box2d,

  # FIXME these should be transitive
  bullet,
  dartsim,
  imgui,

  # keep-sorted start case=no numeric=no block=yes
  withAnimatedGifExample ? true,
  withArcballExample ? true,
  withArealightsExample ? true, # FIXME: TrueType
  withAudioExample ? true,
  withBox2dExample ? true,
  withBulletExample ? true,
  withCubemapExample ? true,
  withDartExample ? true,
  withFluidsimulation2dExample ? true,
  withFluidsimulation3dExample ? true,
  withImguiExample ? true,
  withMotionblurExample ? true,
  withMouseinteractionExample ? true,
  withMultidrawExample ? true, # not sure how to run it
  withOctreeExample ? true,
  withPickingExample ? true,
  withPrimitivesExample ? true,
  withRaytracingExample ? true,
  withShadowsExample ? true,
  withTextExample ? true, # XXX: strange scaling
  withTexturedquadExample ? true,
  withTriangleExample ? true,
  withTrianglePlainGlfwExample ? true,
  withViewerExample ? true,
  # keep-sorted end

  # The following examples are currently failing:

  # fails
  # unit tests for magnum's withVulkan fail
  withTexturedtriangleVulkanExample ? false,
  withTriangleVulkanExample ? false,
  # withTriangleSokolExample fails with:
  # magnum-examples> /build/source/src/triangle-sokol/TriangleSokolExample.cpp:82:5: error: 'flextInit' was not declared in this scope; did you mean 'flextGLInit'?
  # magnum-examples>    82 |     flextInit();
  withTriangleSokolExample ? false,
}:

let
  magnumWithPlugins = magnum.withPlugins [
    (magnum-plugins.override (
      lib.optionalAttrs withAnimatedGifExample { withStbImageImporter = true; }
      # FIXME: Text::FreeTypeFont::fillGlyphCache(): cannot fit 96 glyphs with a total area of 330719 pixels into a cache of size Vector(1024, 512, 1) and Vector(1024, 174, 1) filled so far
      // lib.optionalAttrs withArealightsExample { withDdsImporter = true; }
      // lib.optionalAttrs withAudioExample { withStbVorbisAudioImporter = true; }
      # XXX: must be run with
      # ./result/bin/magnum-cubemap ./result/share/magnum/examples/cubemap/
      // lib.optionalAttrs withCubemapExample { withJpegImporter = true; }
      # XXX: withDartIntegration already needs this plugin, this should be transitive?
      // lib.optionalAttrs withDartExample { withAssimpImporter = true; }
      // lib.optionalAttrs withTexturedquadExample { withStbImageImporter = true; }
    ))
    (magnum-integration.override (
      lib.optionalAttrs withBulletExample { withBulletIntegration = true; }
      // lib.optionalAttrs withDartExample { withDartIntegration = true; }
      // lib.optionalAttrs (
        withImguiExample || withFluidsimulation2dExample || withFluidsimulation3dExample
      ) { withImguiIntegration = true; }
    ))
    (magnum-extras.override (lib.optionalAttrs withArealightsExample { withUi = true; }))
  ];
in

assert lib.assertMsg (!withTriangleExample || magnum.args.withSDL2Application)
  "magnum-examples: withTriangleExample=true requires magnum to be built with withSDL2Application=true";

assert lib.assertMsg (!(withTexturedtriangleVulkanExample && !magnum.args.withVulkan))
  "magnum-examples: withTexturedtriangleVulkanExample=true requires magnum to be built with withVulkan=true";

assert lib.assertMsg (!(withTrianglePlainGlfwExample && !magnum.args.withGlxContext))
  "magnum-examples: withTrianglePlainGlfwExample=true requires magnum to be built with withGlxContext=true";

stdenv.mkDerivation {
  pname = "magnum-examples";
  version = "2020.06-unstable-2026-10-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-examples";
    rev = "83dd3787219bda6acdd37f7d8a22af2ce4ce6e03";
    hash = "sha256-SFwvQH49AsxUyo9qu52lExFLfkawcW8KHsUuFo6OQjo=";
  };

  nativeBuildInputs = [
    cmake
    corrade # Makes corrade-rc accessible during build
  ];
  propagatedBuildInputs = [
    magnumWithPlugins
  ]
  ++ lib.optional withBox2dExample box2d
  ++ lib.optional withBulletExample bullet # FIXME: this should be a propagatedBuildInputs since withBulletIntegration depends on it
  ++ lib.optional withDartExample dartsim # FIXME: this should be a propagatedBuildInputs since withBulletIntegration depends on it
  # same issue with these dependencies
  ++ lib.optional (
    withImguiExample || withFluidsimulation2dExample || withFluidsimulation3dExample
  ) imgui;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    # keep-sorted start case=no numeric=no block=yes
    (lib.cmakeBool "MAGNUM_WITH_ANIMATED_GIF_EXAMPLE" withAnimatedGifExample)
    (lib.cmakeBool "MAGNUM_WITH_ARCBALL_EXAMPLE" withArcballExample)
    (lib.cmakeBool "MAGNUM_WITH_AREALIGHTS_EXAMPLE" withArealightsExample)
    (lib.cmakeBool "MAGNUM_WITH_AUDIO_EXAMPLE" withAudioExample)
    (lib.cmakeBool "MAGNUM_WITH_BOX2D_EXAMPLE" withBox2dExample)
    (lib.cmakeBool "MAGNUM_WITH_BULLET_EXAMPLE" withBulletExample)
    (lib.cmakeBool "MAGNUM_WITH_CUBEMAP_EXAMPLE" withCubemapExample)
    (lib.cmakeBool "MAGNUM_WITH_DART_EXAMPLE" withDartExample)
    (lib.cmakeBool "MAGNUM_WITH_FLUIDSIMULATION2D_EXAMPLE" withFluidsimulation2dExample)
    (lib.cmakeBool "MAGNUM_WITH_FLUIDSIMULATION3D_EXAMPLE" withFluidsimulation3dExample)
    (lib.cmakeBool "MAGNUM_WITH_IMGUI_EXAMPLE" withImguiExample)
    (lib.cmakeBool "MAGNUM_WITH_MOTIONBLUR_EXAMPLE" withMotionblurExample)
    (lib.cmakeBool "MAGNUM_WITH_MOUSEINTERACTION_EXAMPLE" withMouseinteractionExample)
    (lib.cmakeBool "MAGNUM_WITH_MULTIDRAW_EXAMPLE" withMultidrawExample)
    (lib.cmakeBool "MAGNUM_WITH_OCTREE_EXAMPLE" withOctreeExample)
    (lib.cmakeBool "MAGNUM_WITH_PICKING_EXAMPLE" withPickingExample)
    (lib.cmakeBool "MAGNUM_WITH_PRIMITIVES_EXAMPLE" withPrimitivesExample)
    (lib.cmakeBool "MAGNUM_WITH_RAYTRACING_EXAMPLE" withRaytracingExample)
    (lib.cmakeBool "MAGNUM_WITH_SHADOWS_EXAMPLE" withShadowsExample)
    (lib.cmakeBool "MAGNUM_WITH_TEXT_EXAMPLE" withTextExample)
    (lib.cmakeBool "MAGNUM_WITH_TEXTUREDQUAD_EXAMPLE" withTexturedquadExample)
    (lib.cmakeBool "MAGNUM_WITH_TEXTUREDTRIANGLE_VULKAN_EXAMPLE" withTexturedtriangleVulkanExample)
    (lib.cmakeBool "MAGNUM_WITH_TRIANGLE_EXAMPLE" withTriangleExample)
    (lib.cmakeBool "MAGNUM_WITH_TRIANGLE_PLAIN_GLFW_EXAMPLE" withTrianglePlainGlfwExample)
    (lib.cmakeBool "MAGNUM_WITH_TRIANGLE_SOKOL_EXAMPLE" withTriangleSokolExample)
    (lib.cmakeBool "MAGNUM_WITH_TRIANGLE_VULKAN_EXAMPLE" withTriangleVulkanExample)
    (lib.cmakeBool "MAGNUM_WITH_VIEWER_EXAMPLE" withViewerExample)
    # keep-sorted end
  ];

  doCheck = true;

  meta = with lib; {
    description = "Examples for the Magnum C++11 graphics engine";
    homepage = "https://github.com/msora/magnum-examples";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
