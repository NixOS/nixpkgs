{
  lib,
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
  stdenv,
  tesseract,
  valgrind,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xcbutil,
  xcbutilwm,
  xz,
  # Boolean flags
  buildManPages ? true,
  useBuiltinLua ? true,
  useEspeak ? !stdenv.isDarwin,
  useStaticLibuvc ? true,
  useStaticOpenAL ? true,
  useStaticSqlite ? true,
  useTracy ? true,
  # Configurable options
  sources ? callPackage ./sources.nix { },
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (sources.letoram-arcan) pname version src;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wayland-scanner
  ] ++ lib.optionals buildManPages [ ruby ];

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
  ] ++ lib.optionals useEspeak [ espeak-ng ];

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

  outputs = [ "out" "dev" "lib" "man" ];

  hardeningDisable = [ "format" ];

  strictDeps = true;

  # Emulate external/git/clone.sh
  postUnpack =
    let
      inherit (sources)
        letoram-openal
        libuvc
        luajit
        tracy
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
    + prepareSource useStaticOpenAL letoram-openal.src "openal"
    + prepareSource useStaticLibuvc libuvc.src "libuvc"
    + prepareSource useBuiltinLua luajit.src "luajit"
    + prepareSource useTracy tracy.src "tracy"
    + ''
      popd
    '';

  postPatch = ''
    substituteInPlace ./src/platform/posix/paths.c \
      --replace-fail "/usr/bin" "$out/bin" \
      --replace-fail "/usr/share" "$out/share"
    substituteInPlace ./src/CMakeLists.txt \
      --replace-fail "SETUID" "# SETUID"
  '';

  # INFO: Arcan build scripts require the manpages to be generated *before* the
  # `configure` phase
  preConfigure = lib.optionalString buildManPages ''
    pushd doc
    ruby docgen.rb mangen
    popd
  '';

  passthru = {
    inherit sources;
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
