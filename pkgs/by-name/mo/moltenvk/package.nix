{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  apple-sdk_15,
  darwinMinVersionHook,
  cereal,
  libcxx,
  glslang,
  spirv-cross,
  spirv-headers,
  spirv-tools,
  vulkan-headers,
  xcbuildHook,
  enableStatic ? stdenv.hostPlatform.isStatic,
  # MoltenVK supports using private APIs to implement some Vulkan functionality.
  # Applications that use private APIs can’t be distributed on the App Store,
  # but that’s not really a concern for nixpkgs, so use them by default.
  # See: https://github.com/KhronosGroup/MoltenVK/blob/main/README.md#metal_private_api
  enablePrivateAPIUsage ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "MoltenVK";
  version = "1.2.11";

  strictDeps = true;

  buildInputs = [
    apple-sdk_15
    cereal
    (darwinMinVersionHook "10.15")
    glslang
    spirv-cross
    spirv-headers
    spirv-tools
    vulkan-headers
  ];

  nativeBuildInputs = [ xcbuildHook ];

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "MoltenVK";
    rev = "v${finalAttrs.version}";
    hash = "sha256-24qQnJ0RnJP2M4zSlSlQ4c4dVZtHutNiCvjrsCDw6wY=";
  };

  patches = [
    # Cherry-pick patch to fix build failure due to a hardcoded SPIRV-Cross namespace.
    # This can be dropped for MoltenVK 1.2.12.
    (fetchpatch2 {
      url = "https://github.com/KhronosGroup/MoltenVK/commit/856c8237ac3b32178caae3408effc35bedfdffa1.patch?full_index=1";
      hash = "sha256-dVTop8sU19Swdb3ajbI+6S715NaxTqd7d0yQ/FDqxqY=";
    })
  ];

  postPatch = ''
    # Move `mvkGitRevDerived.h` to a stable location
    substituteInPlace Scripts/gen_moltenvk_rev_hdr.sh \
      --replace-fail '$'''{BUILT_PRODUCTS_DIR}' "$NIX_BUILD_TOP/$sourceRoot/build/include" \
      --replace-fail '$(git rev-parse HEAD)' ${finalAttrs.src.rev}

    # Modify MoltenVK Xcode projects to build with xcbuild and dependencies from nixpkgs.
    for proj in MoltenVK MoltenVKShaderConverter; do
      # Remove xcframework dependencies from the Xcode projects. The basic format is:
      #     (children|files) = (
      #         DCFD7F822A45BDA0007BBBF7 /* SPIRVCross.xcframework in Frameworks */,
      #         etc
      #     )
      # This regex will only remove lines matching `xcframework` that are in these blocks
      # to avoid accidentally corrupting the project.
      sed -E -e '/(children|files) = /,/;/{/xcframework/d}' \
        -i "$proj/$proj.xcodeproj/project.pbxproj"
      # Ensure the namespace used is consistent with the spirv-cross package in nixpkgs.
      substituteInPlace "$proj/$proj.xcodeproj/project.pbxproj" \
        --replace-fail SPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross SPIRV_CROSS_NAMESPACE_OVERRIDE=spirv_cross
    done
    substituteInPlace MoltenVKShaderConverter/MoltenVKShaderConverter.xcodeproj/project.pbxproj \
      --replace-fail MetalGLShaderConverterTool MoltenVKShaderConverter \
      --replace-fail MetalGLShaderConverter-macOS MoltenVKShaderConverter

    # Don’t try to build `xcframework`s because `xcbuild` can’t build them.
    sed -e '/xcframework/d' -i Scripts/package_all.sh

    # Remove vendored dependency links.
    find . -lname '*/External/*' -delete

    # The library will be linked in the install phase regardless of version,
    # so truncate it if it exists to avoid link failures.
    test -f Scripts/create_dylib.sh && truncate --size 0 Scripts/create_dylib.sh

    # Link glslang source because MoltenVK needs non-public headers to build.
    mkdir -p build/include
    ln -s "${glslang.src}" "build/include/glslang"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-isystem ${lib.getDev libcxx}/include/c++/v1"
      "-I${lib.getDev spirv-cross}/include/spirv_cross"
      "-I${lib.getDev spirv-headers}/include/spirv/unified1"

      # MoltenVK prints a lot of verbose output to the console out of
      # the box; we adjust this to match Homebrew’s default log level.
      "-DMVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE"
    ]
    ++ lib.optional enablePrivateAPIUsage "-DMVK_USE_METAL_PRIVATE_API=1"
  );

  env.NIX_LDFLAGS = toString [
    "-lglslang"
    "-lSPIRV"
    "-lSPIRV-Tools"
    "-lSPIRV-Tools-opt"
    "-lspirv-cross-msl"
    "-lspirv-cross-core"
    "-lspirv-cross-glsl"
    "-lspirv-cross-reflect"
  ];

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" \
      -I$NIX_BUILD_TOP/$sourceRoot/build/include \
      -I$NIX_BUILD_TOP/$sourceRoot/Common"
  '';

  xcbuildFlags = [
    "-configuration"
    "Release"
    "-project"
    "MoltenVKPackaging.xcodeproj"
    "-scheme"
    "MoltenVK Package (macOS only)"
    "-destination"
    "generic/platform=macOS"
    "-arch"
    stdenv.hostPlatform.darwinArch
  ];

  postBuild =
    if enableStatic then
      ''
        mkdir -p Package/Release/MoltenVK/static
        cp Products/Release/libMoltenVK.a Package/Release/MoltenVK/static
      ''
    else
      ''
        # MoltenVK’s Xcode project builds the dylib, but it doesn’t seem to work with
        # xcbuild. This is based on the script versions prior to 1.2.8 used.
        mkdir -p Package/Release/MoltenVK/dynamic/dylib
        clang++ -Wl,-all_load -Wl,-w \
          -dynamiclib \
          -compatibility_version 1.0.0 -current_version 1.0.0 \
          -LProducts/Release \
          -framework AppKit \
          -framework CoreGraphics \
          -framework Foundation \
          -framework IOKit \
          -framework IOSurface \
          -framework Metal \
          -framework QuartzCore \
          -lobjc \
          -lMoltenVKShaderConverter \
          -lspirv-cross-reflect \
          -install_name "$out/lib/libMoltenVK.dylib" \
          -o Package/Release/MoltenVK/dynamic/dylib/libMoltenVK.dylib \
          -force_load Products/Release/libMoltenVK.a
      '';

  installPhase = ''
    runHook preInstall

    libraryExtension=${if enableStatic then ".a" else ".dylib"}
    packagePath=${if enableStatic then "static" else "dynamic/dylib"}

    mkdir -p "$out/lib" "$out/share/vulkan/icd.d" "$bin/bin" "$dev"

    cp Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter "$bin/bin"
    cp -r Package/Release/MoltenVK/include "$dev"
    cp Package/Release/MoltenVK/$packagePath/libMoltenVK$libraryExtension "$out/lib"

    # Install ICD definition for use with vulkan-loader.
    install -m644 MoltenVK/icd/MoltenVK_icd.json \
      "$out/share/vulkan/icd.d/MoltenVK_icd.json"
    substituteInPlace "$out/share/vulkan/icd.d/MoltenVK_icd.json" \
      --replace-fail ./libMoltenVK.dylib "$out/lib/libMoltenVK.dylib"

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = ".*-(beta|rc).*";
  };

  meta = {
    description = "Vulkan Portability implementation built on top of Apple’s Metal API";
    homepage = "https://github.com/KhronosGroup/MoltenVK";
    changelog = "https://github.com/KhronosGroup/MoltenVK/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
  };
})
