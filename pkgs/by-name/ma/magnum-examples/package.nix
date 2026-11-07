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

  # keep-sorted start case=no numeric=no block=yes
  withAnimatedGifExample ? true,
  withArcballExample ? true,
  withArealightsExample ? true,
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
  withTexturedtriangleVulkanExample ? true,
  withTriangleExample ? true,
  withTrianglePlainGlfwExample ? true,
  withTriangleVulkanExample ? true,
  withViewerExample ? true,
  # keep-sorted end

  # The following examples are currently failing:

  # Build fails
  # Mutually exclusive with all other plugins, as it needs
  # MAGNUM_TARGET_GL=false and MAGNUM_WITH_GL=false
  # This should probably be built in another derivation
  withTriangleSokolExample ? false,
}:

let
  # Magnum with the correct build options depending on which examples are enabled
  magnumWithOpts =
    magnum.override { }
    // lib.optionalAttrs withTriangleExample { withSdl2Application = true; }
    // lib.optionalAttrs withTexturedtriangleVulkanExample { withVulkan = true; }
    // lib.optionalAttrs withTrianglePlainGlfwExample { withGlxContext = true; }
    // lib.optionalAttrs withTriangleVulkanExample { withAnyImageConverter = true; };

  magnumPlugins = magnum-plugins.override (
    lib.optionalAttrs withAnimatedGifExample { withStbImageImporter = true; }
    # FIXME: Text::FreeTypeFont::fillGlyphCache(): cannot fit 96 glyphs with a total area of 330719 pixels into a cache of size Vector(1024, 512, 1) and Vector(1024, 174, 1) filled so far
    # => this is a known issue where the text rendering glyph cache doesn't take high DPI (desktop scaling 2x and higher) into account properly and is too small. The multidraw example and the magnum-ui-gallery both likely fail with the same issue, a shitty workaround is to run them with --magnum-dpi-scaling 1, it'll cause the window to be too small but it won't crash.
    // lib.optionalAttrs withArealightsExample { withDdsImporter = true; }
    // lib.optionalAttrs withAudioExample { withStbVorbisAudioImporter = true; }
    # XXX: must be run with
    # $ ./result/bin/magnum-cubemap ./result/share/magnum/examples/cubemap/
    // lib.optionalAttrs withCubemapExample { withJpegImporter = true; }
    # XXX: withDartIntegration in magnum-integration already needs this plugin, this should be transitive?
    // lib.optionalAttrs withDartExample { withAssimpImporter = true; }
    // lib.optionalAttrs withTexturedquadExample { withStbImageImporter = true; }
    // lib.optionalAttrs withTriangleVulkanExample {
      withSpirvToolsShaderConverter = true;
      withPngImageConverter = true;
    }
  );

  magnumIntegration = magnum-integration.override (
    lib.optionalAttrs withBulletExample { withBulletIntegration = true; }
    // lib.optionalAttrs withDartExample { withDartIntegration = true; }
    // lib.optionalAttrs (
      withImguiExample || withFluidsimulation2dExample || withFluidsimulation3dExample
    ) { withImguiIntegration = true; }
  );

  magnumExtras = magnum-extras.override (lib.optionalAttrs withArealightsExample { withUi = true; });

  # This example builds only if magnum itself is built with MAGNUM_TARGET_GL and MAGNUM_WITH_GL disabled, which practically removes all functionality except for the math library and asset pipeline.
  magnumSokol =
    (magnum.override {
      withTargetGL = false;
      withGL = false;
      withGlxApplication = false;
      withWindowlessGlxApplication = false;
      withGlxContext = false;
    }).overrideAttrs
      { pname = "${magnum.pname}-sokol"; };

  magnumWithPlugins =
    let
      m = if withTriangleSokolExample then magnumSokol else magnumWithOpts;
    in
    m.withPlugins [
      magnumPlugins
      magnumIntegration
      magnumExtras
    ];

  allExamples = {
    # keep-sorted start case=no numeric=no block=yes
    inherit withAnimatedGifExample;
    inherit withArcballExample;
    inherit withArealightsExample; # FIXME: falseType
    inherit withAudioExample;
    inherit withBox2dExample;
    inherit withBulletExample;
    inherit withCubemapExample;
    inherit withDartExample;
    inherit withFluidsimulation2dExample;
    inherit withFluidsimulation3dExample;
    inherit withImguiExample;
    inherit withMotionblurExample;
    inherit withMouseinteractionExample;
    inherit withMultidrawExample; # not sure how to run it
    inherit withOctreeExample;
    inherit withPickingExample;
    inherit withPrimitivesExample;
    inherit withRaytracingExample;
    inherit withShadowsExample;
    inherit withTextExample; # XXX: strange scaling
    inherit withTexturedquadExample;
    inherit withTriangleExample;
    inherit withTrianglePlainGlfwExample;
    inherit withTriangleSokolExample;
    inherit withViewerExample;
    # keep-sorted end
  };
  examplesWithoutTriangleSokol = lib.removeAttrs allExamples [ "withTriangleSokolExample" ];
  anyNonSokolExampleEnabled = lib.any (x: x) (lib.attrValues examplesWithoutTriangleSokol);

in

# withTriangleSokolExample requires magnum to be built with MAGNUM_TARGET_GL=false and MAGNUM_WITH_GL=false, which practically disables all other examples, so we assert that no other example is enabled if withTriangleSokolExample is true
assert lib.assertMsg (
  !withTriangleSokolExample || !anyNonSokolExampleEnabled
) "magnum-examples: withTriangleSokol=true requires all other examples to be disabled";

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
  propagatedBuildInputs =
    let
      prop = (
        [
          magnumWithPlugins
        ]
        ++ lib.optional withBox2dExample box2d
      );
    in
    builtins.trace "magnum-examples: propagatedBuildInputs: ${toString prop}" prop;

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
    homepage = "https://github.com/mosra/magnum-examples";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
