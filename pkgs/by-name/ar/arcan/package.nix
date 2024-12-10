{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  callPackage,
  cmake,
  espeak-ng,
  ffmpeg,
  file,
  freetype,
  glib,
  gumbo,
  harfbuzz,
  jbig2dec,
  leptonica,
  libGL,
  libX11,
  libXau,
  libXcomposite,
  libXdmcp,
  libXfixes,
  libdrm,
  libffi,
  libjpeg,
  libusb1,
  libuvc,
  libvlc,
  libvncserver,
  libxcb,
  libxkbcommon,
  makeWrapper,
  mesa,
  mupdf,
  openal,
  openjpeg,
  pcre2,
  pkg-config,
  ruby,
  sqlite,
  tesseract,
  valgrind,
  wayland,
  wayland-protocols,
  xcbutil,
  xcbutilwm,
  xz,
  buildManPages ? true,
  useBuiltinLua ? true,
  useEspeak ? !stdenv.isDarwin,
  useStaticLibuvc ? true,
  useStaticOpenAL ? true,
  useStaticSqlite ? true,
  useTracy ? true,
}:

let
  allSources = {
    letoram-arcan = {
      pname = "arcan";
      version = "0.6.2.1-unstable-2023-11-18";
      src = fetchFromGitHub {
        owner = "letoram";
        repo = "arcan";
        rev = "0950ee236f96a555729498d0fdf91c16901037f5";
        hash = "sha256-TxadRlidy4KRaQ4HunPO6ISJqm6JwnMRM8y6dX6vqJ4=";
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
      rev = "68d07a00e11d1944e27b7295ee69673239c00b4b";
      hash = "sha256-IdV18mnPTDBODpS1BXl4ulkFyf1PU2ZmuVGNOIdQwzE=";
    };
    luajit-src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "656ecbcf8f669feb94e0d0ec4b4f59190bcd2e48";
      hash = "sha256-/gGQzHgYuWGqGjgpEl18Rbh3Sx2VP+zLlx4N9/hbYLc=";
    };
    tracy-src = fetchFromGitHub {
      owner = "wolfpld";
      repo = "tracy";
      rev = "93537dff336e0796b01262e8271e4d63bf39f195";
      hash = "sha256-FNB2zTbwk8hMNmhofz9GMts7dvH9phBRVIdgVjRcyQM=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit (allSources.letoram-arcan) pname version src;

  nativeBuildInputs =
    [
      cmake
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals buildManPages [
      ruby
    ];

  buildInputs =
    [
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
  postUnpack =
    let
      inherit (allSources)
        letoram-openal-src
        libuvc-src
        luajit-src
        tracy-src
        ;
      prepareSource =
        flag: source: destination:
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
    license = with lib.licenses; [
      bsd3
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
