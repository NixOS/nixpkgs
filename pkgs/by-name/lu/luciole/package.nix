{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3Minimal,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libglvnd,
  libxkbcommon,
  freetype,
  fontconfig,
  cairo,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  dconf,
  gvfs,
  curl,
  libxml2,
  pango,
  harfbuzz,
  libpng,
  libarchive,
  xz,
  acl,
  libwebp,
  librsvg,
  gdk-pixbuf,
  stb,
  ffmpeg,
  ffmpegthumbnailer,
  poppler-utils,
  _7zz,
  nlohmann_json,
  tomlplusplus,
  autoAddDriverRunpath,
  makeWrapper,
  adwaita-icon-theme,
  shared-mime-info,
  xdg-terminal-exec,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "luciole";
  version = "0-unstable-2026-11-18";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "luciole";
    rev = "83856751534bd13d06632f37b95892b20928deec";
    hash = "sha256-+rTih4gof6ooZb/Szvxw5YuBhAIIAJGxAXXeXIAWUhk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Minimal
    wayland-scanner
    autoAddDriverRunpath
    makeWrapper
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libglvnd
    libxkbcommon
    freetype
    fontconfig
    cairo
    glib
    curl
    libxml2
    pango
    harfbuzz
    libpng
    libarchive
    xz
    acl
    libwebp
    gdk-pixbuf
    librsvg
    stb
    nlohmann_json
    tomlplusplus
  ];

  # GNU LTO archives need the compiler's plugin-aware tools.
  preConfigure = lib.optionalString stdenv.cc.isGNU ''
    export AR="${stdenv.cc.cc}/bin/gcc-ar"
    export RANLIB="${stdenv.cc.cc}/bin/gcc-ranlib"
  '';

  mesonBuildType = "release";

  postFixup = ''
    wrapProgram "$out/bin/luciole" \
      --prefix PATH : "${
        lib.makeBinPath [
          xdg-terminal-exec
          ffmpeg
          ffmpegthumbnailer
          poppler-utils
          _7zz
        ]
      }" \
      --suffix GIO_EXTRA_MODULES : "${
        lib.makeSearchPath "lib/gio/modules" [
          gvfs
          glib-networking
          dconf.lib
        ]
      }" \
      --suffix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath gsettings-desktop-schemas}:${
        lib.makeSearchPath "share" [
          adwaita-icon-theme
          shared-mime-info
        ]
      }"
  '';

  mesonFlags = [
    # Tests require a running Wayland/graphical environment
    "-Dtests=disabled"
    (lib.mesonOption "build_revision" (builtins.substring 0 7 finalAttrs.src.rev))
  ];

  meta = {
    description = "Native Wayland file manager using Noctalia rendering and controls";
    homepage = "https://github.com/noctalia-dev/luciole";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cleboost ];
    platforms = lib.platforms.linux;
    mainProgram = finalAttrs.pname;
  };
})
