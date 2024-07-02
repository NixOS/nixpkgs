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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skia";
  # Version from https://skia.googlesource.com/skia/+/refs/heads/main/RELEASE_NOTES.md
  # plus date of the tip of the corresponding chrome/m* branch
  version = "127-unstable-2024-06-11";

  src = fetchgit {
    url = "https://skia.googlesource.com/skia.git";
    rev = "1c8089adffdabe3790cc4ca4fb36e24c2f6ab792";
    hash = "sha256-02g5X3eNlCDB3K1OWzevDbYMR+k+9FhhyDe5GJbhqT0=";
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
    libX11
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

  meta = {
    description = "2D graphic library for drawing text, geometries and images";
    homepage = "https://skia.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
