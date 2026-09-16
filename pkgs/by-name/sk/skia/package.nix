{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  expat,
  fontconfig,
  freetype,
  harfbuzzFull,
  icu,
  gn,
  libGL,
  libjpeg,
  libwebp,
  libx11,
  ninja,
  python3,
  testers,
  vulkan-headers,
  vulkan-memory-allocator,
  xcbuild,
  cctools,
  zlib,
  fixDarwinDylibNames,

  enableVulkan ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skia";
  # Version from https://skia.googlesource.com/skia/+/refs/heads/main/RELEASE_NOTES.md
  # or https://chromiumdash.appspot.com/releases
  # plus the date of the selected commit on the corresponding chrome/m$version branch
  version = "148-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "skia";
    # Revision used by Ladybird's vcpkg baseline:
    # https://github.com/microsoft/vcpkg/blob/7f3781e19cc7d4e4882a4caec01668c6f7b5c163/ports/skia/portfile.cmake
    rev = "e7c90ecca9444fe09598f1630ab7cee2c0ee027a";
    hash = "sha256-2+fxWqkNBStoN6l5Y3xMqkwvh69sCU6A//wz8fMnmjY=";
  };

  patches = [
    # A tiny patch to fix build errors on loongarch64-linux using GCC (Clang works fine).
    # https://skia-review.googlesource.com/c/skia/+/1199836
    (fetchpatch2 {
      url = "https://salsa.debian.org/fonts-team/libskia/-/raw/6574ca599eab076a9cd5b8667f81aef0f67b3eeb/debian/patches/loong-build";
      hash = "sha256-6dUCQixmll2K8fqRGwhay7ee8gvdRq1NJjUHBHxIFvo=";
    })
  ];

  postPatch = ''
    substituteInPlace BUILD.gn \
      --replace-fail 'rebase_path("//bin/gn")' '"gn"'
    # System zlib detection bug workaround
    substituteInPlace BUILD.gn \
      --replace-fail '"//third_party/zlib",' ""
  '';

  strictDeps = true;
  nativeBuildInputs = [
    gn
    ninja
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    cctools.libtool
    zlib
    fixDarwinDylibNames
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    harfbuzzFull
    icu
    libGL
    libjpeg
    libwebp
    libx11
  ]
  ++ lib.optionals enableVulkan [
    vulkan-headers
    vulkan-memory-allocator
  ];

  gnFlags =
    let
      cpu =
        {
          "x86_64" = "x64";
          "i686" = "x86";
          "arm" = "arm";
          "aarch64" = "arm64";
          "loongarch64" = "loong64";
        }
        .${stdenv.hostPlatform.parsed.cpu.name};
    in
    [
      # Build in release mode
      "is_official_build=true"
      "is_component_build=true"
      # Don't use missing tools
      "skia_use_dng_sdk=false"
      "skia_use_wuffs=false"
      # Use system dependencies
      "extra_cflags=[\"-I${harfbuzzFull.dev}/include/harfbuzz\"]"
      "cc=\"${stdenv.cc.targetPrefix}cc\""
      "cxx=\"${stdenv.cc.targetPrefix}c++\""
      "ar=\"${stdenv.cc.targetPrefix}ar\""
      "target_cpu=\"${cpu}\""
    ]
    ++ map (lib: "skia_use_system_${lib}=true") [
      "zlib"
      "harfbuzz"
      "libpng"
      "libwebp"
    ]
    ++ lib.optionals enableVulkan [
      "skia_use_vulkan=true"
      "extra_cflags+=[\"-DSK_USE_EXTERNAL_VULKAN_HEADERS\"]"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "skia_use_fontconfig=true"
      "skia_use_freetype=true"
      "skia_use_metal=true"
    ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lz";

  # Somewhat arbitrary, but similar to what other distros are doing
  installPhase = ''
    runHook preInstall

    # Libraries
    mkdir -p $out/lib
    cp *.so *.a *.dylib $out/lib

    # Includes
    pushd ../../include
    find . -name '*.h' -exec install -Dm644 {} $out/include/skia/{} \;
    popd
    pushd ../../modules
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
    platforms = with lib.platforms; arm ++ aarch64 ++ x86 ++ x86_64 ++ loongarch64;
    pkgConfigModules = [ "skia" ];
  };
})
