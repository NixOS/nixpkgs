{ lib
, stdenv
, fetchFromGitHub
, SDL2
, callPackage
, cmake
, espeak-ng
, ffmpeg
, file
, freetype
, glib
, gumbo
, harfbuzz
, jbig2dec
, leptonica
, libGL
, libX11
, libXau
, libXcomposite
, libXdmcp
, libXfixes
, libdrm
, libffi
, libjpeg
, libusb1
, libuvc
, libunwind
, libvlc
, libvncserver
, libxcb
, libxkbcommon
, makeWrapper
, mesa
, mupdf
, openal
, openjpeg
, pcre2
, pkg-config
, ruby
, sqlite
, tesseract
, valgrind
, wayland
, wayland-protocols
, xcbutil
, xcbutilwm
, xz
, buildManPages ? true
, useBuiltinLua ? true
, useEspeak ? !stdenv.isDarwin
, useStaticLibuvc ? true
, useStaticOpenAL ? true
, useStaticSqlite ? true
, useTracy ? true
}:

let
  allSources = {
    letoram-arcan = {
      pname = "arcan";
      version = "0.6.3.0-unstable-2024-06-01";
      src = fetchFromGitHub {
        owner = "letoram";
        repo = "arcan";
        rev = "1f9b22fad18f5b1fd4994699538458501dda2db7";
        hash = "sha256-Foi8UF3kB5eOX89R/m2bx6yXGnwI/e+fREF/G4NrzPo=";
      };
    };
    letoram-openal-src = fetchFromGitHub {
      owner = "letoram";
      repo = "openal";
      rev = "81e1b364339b6aa2b183f39fc16c55eb5857e97a";
      hash = "sha256-X3C3TDZPiOhdZdpApC4h4KeBiWFMxkFsmE3gQ1Rz420=";
    };
    libuvc-src = fetchFromGitHub {
      owner = "libuvc";
      repo = "libuvc";
      rev = "047920bcdfb1dac42424c90de5cc77dfc9fba04d";
      hash = "sha256-Ds4N9ezdO44eBszushQVvK0SUVDwxGkUty386VGqbT0=";
    };
    luajit-src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "4a22050df9e76a28ef904382e4b4c69578973cd5";
      hash = "sha256-H9xWEh/g23xaoyQ8B5pxM76V+MFLTwQ+BgSFk04r4C0=";
    };
    tracy-src = fetchFromGitHub {
      owner = "letoram";
      repo = "tracy";
      rev = "5b3513d9838317bfc0e72344b94aa4443943c2fd";
      hash = "sha256-hUdYC4ziQ7V7T7k99MERp81F5mPHzFtPFrqReWsTjOQ=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit (allSources.letoram-arcan) pname version src;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ] ++ lib.optionals buildManPages [
    ruby
  ];

  buildInputs = [
    SDL2
    ffmpeg
    file
    freetype
    glib
    gumbo
    harfbuzz
    jbig2dec
    leptonica
    libGL
    libX11
    libXau
    libXcomposite
    libXdmcp
    libXfixes
    libdrm
    libffi
    libjpeg
    libusb1
    libunwind
    libuvc
    libvlc
    libvncserver
    libxcb
    libxkbcommon
    mesa
    mupdf
    openal
    openjpeg
    pcre2
    sqlite
    tesseract
    valgrind
    wayland
    wayland-protocols
    xcbutil
    xcbutilwm
    xz
  ]
  ++ lib.optionals useEspeak [
    espeak-ng
  ];

  # Emulate external/git/clone.sh
  postUnpack = let
    inherit (allSources)
      letoram-openal-src libuvc-src luajit-src tracy-src;
    prepareSource = flag: source: destination:
      lib.optionalString flag ''
        cp -va ${source}/ ${destination}
        chmod --recursive 744 ${destination}
      '';
  in
    ''
      pushd $sourceRoot/external/git/
    ''
    + prepareSource useStaticOpenAL letoram-openal-src "openal"
    + prepareSource useStaticLibuvc libuvc-src "libuvc"
    + prepareSource useBuiltinLua luajit-src "luajit"
    + prepareSource useTracy tracy-src "tracy"
    + ''
      popd
    '';

  postPatch = ''
    substituteInPlace ./src/platform/posix/paths.c \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/share"
    substituteInPlace ./src/CMakeLists.txt \
      --replace "SETUID" "# SETUID"
  '';

  # INFO: Arcan build scripts require the manpages to be generated *before* the
  # `configure` phase
  preConfigure = lib.optionalString buildManPages ''
    pushd doc
    ruby docgen.rb mangen
    popd
  '';

  cmakeFlags = [
    # The upstream project recommends tagging the distribution
    (lib.cmakeFeature "DISTR_TAG" "Nixpkgs")
    (lib.cmakeFeature "ENGINE_BUILDTAG" finalAttrs.src.rev)
    (lib.cmakeFeature "BUILD_PRESET" "everything")
    (lib.cmakeBool "BUILTIN_LUA" useBuiltinLua)
    (lib.cmakeBool "DISABLE_JIT" useBuiltinLua)
    (lib.cmakeBool "STATIC_LIBUVC" useStaticLibuvc)
    (lib.cmakeBool "STATIC_SQLite3" useStaticSqlite)
    (lib.cmakeBool "ENABLE_TRACY" useTracy)
    (lib.cmakeBool "TRACY_LIBUNWIND_BACKTRACE" false)
    "../src"
  ];

  hardeningDisable = [
    "format"
  ];

  passthru = {
    wrapper = callPackage ./wrapper.nix { };
  };

  meta = {
    homepage = "https://arcan-fe.com/";
    description = "Combined Display Server, Multimedia Framework, Game Engine";
    longDescription = ''
      Arcan is a portable and fast self-sufficient multimedia engine for
      advanced visualization and analysis work in a wide range of applications
      e.g. game development, real-time streaming video, monitoring and
      surveillance, up to and including desktop compositors and window managers.
    '';
    license = with lib.licenses; [ bsd3 gpl2Plus lgpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
