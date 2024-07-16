{ lib
, stdenv
, fetchgit
, expat
, fontconfig
, freetype
, harfbuzzFull
, icu
, gn
, libGL
, libjpeg
, libwebp
, libX11
, ninja
, python3
, testers
, vulkan-headers
, vulkan-memory-allocator
, xcbuild

, enableVulkan ? !stdenv.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skia";
  # Version from https://skia.googlesource.com/skia/+/refs/heads/main/RELEASE_NOTES.md
  # or https://chromiumdash.appspot.com/releases
  # plus date of the tip of the corresponding chrome/m$version branch
  version = "124-unstable-2024-05-22";

  src = fetchgit {
    url = "https://skia.googlesource.com/skia.git";
    # Tip of the chrome/m$version branch
    rev = "a747f7ea37db6ea3871816dbaf2eb41b5776c826";
    hash = "sha256-zHfv4OZK/nVJc2rl+dBSCc4f6qndpAKcFZtThw06+LY=";
  };

  postPatch = ''
    # System zlib detection bug workaround
    substituteInPlace BUILD.gn \
      --replace-fail 'deps = [ "//third_party/zlib" ]' 'deps = []'
  '';

  nativeBuildInputs = [
    gn
    ninja
    python3
  ] ++ lib.optional stdenv.isDarwin xcbuild;

  buildInputs = [
    expat
    fontconfig
    freetype
    harfbuzzFull
    icu
    libGL
    libjpeg
    libwebp
    libX11
  ] ++ lib.optionals enableVulkan [
    vulkan-headers
    vulkan-memory-allocator
  ];

  configurePhase = ''
    runHook preConfigure
    gn gen build --args='${toString ([
      # Build in release mode
      "is_official_build=true"
      "is_component_build=true"
      # Don't use missing tools
      "skia_use_dng_sdk=false"
      "skia_use_wuffs=false"
      # Use system dependencies
      "extra_cflags=[\"-I${harfbuzzFull.dev}/include/harfbuzz\"]"
    ] ++ map (lib: "skia_use_system_${lib}=true") [
      "zlib"
      "harfbuzz"
      "libpng"
      "libwebp"
    ] ++ lib.optionals enableVulkan [
      "skia_use_vulkan=true"
    ])}'
    cd build
    runHook postConfigure
  '';

  # Somewhat arbitrary, but similar to what other distros are doing
  installPhase = ''
    runHook preInstall

    # Libraries
    mkdir -p $out/lib
    cp *.so *.a $out/lib

    # Includes
    pushd ../include
    find . -name '*.h' -exec install -Dm644 {} $out/include/skia/{} \;
    popd
    pushd ../modules
    find . -name '*.h' -exec install -Dm644 {} $out/include/skia/modules/{} \;
    popd

    # Pkg-config
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/skia.pc <<'EOF'
    prefix=${placeholder "out"}
    exec_prefix=''${prefix}
    libdir=''${prefix}/lib
    includedir=''${prefix}/include/skia
    Name: skia
    Description: 2D graphic library for drawing text, geometries and images.
    URL: https://skia.org/
    Version: ${lib.versions.major finalAttrs.version}
    Libs: -L''${libdir} -lskia
    Cflags: -I''${includedir}
    EOF

    runHook postInstall
  '';

  preFixup = ''
    # Some skia includes are assumed to be under an include sub directory by
    # other includes
    for file in $(grep -rl '#include "include/' $out/include); do
      substituteInPlace "$file" \
        --replace-fail '#include "include/' '#include "'
    done
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "2D graphic library for drawing text, geometries and images";
    homepage = "https://skia.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "skia" ];
    # https://github.com/NixOS/nixpkgs/pull/325871#issuecomment-2220610016
    broken = stdenv.isDarwin;
  };
})
