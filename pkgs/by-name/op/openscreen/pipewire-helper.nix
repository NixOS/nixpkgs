# Wayland screen capture through xdg-desktop-portal and PipeWire, plus cursor sampling.
{
  lib,
  rustPlatform,
  symlinkJoin,
  pkg-config,
  patchelfUnstable,
  pipewire,
  libglvnd,
  version,
  src,
  ffmpeg-lgpl,
}:
rustPlatform.buildRustPackage {
  pname = "openscreen-pipewire-helper";
  inherit version src;
  sourceRoot = "${src.name}/electron/native/pipewire-capture";

  cargoHash = "sha256-OikoJ8u86npxcYzNrqTfJBg7yapKHuoM1EzOD/KQlPw=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    patchelfUnstable
  ];
  buildInputs = [ ffmpeg-lgpl ];

  env.FFMPEG_DIR = symlinkJoin {
    name = "ffmpeg-lgpl-tree";
    paths = [
      ffmpeg-lgpl.dev
      ffmpeg-lgpl.lib
    ];
  };

  # libpipewire and libEGL are reached through dlopen; build.rs asks for DT_RPATH.
  postFixup = ''
    patchelf --force-rpath --add-rpath ${
      lib.makeLibraryPath [
        pipewire
        libglvnd
      ]
    } $out/bin/openscreen-pipewire-helper
  '';

  doCheck = false;

  meta = {
    description = "PipeWire capture helper for OpenScreen";
    homepage = "https://github.com/getopenscreen/openscreen";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "openscreen-pipewire-helper";
  };
}
