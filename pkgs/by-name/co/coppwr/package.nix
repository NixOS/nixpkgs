{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  pipewire,
  vulkan-loader,
  wayland,
  libGL,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coppwr";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
    tag = finalAttrs.version;
    hash = "sha256-L0MpMh3HuWX0zxG50OGZDa+wX5E55/dU6jt6Iei99Ho=";
  };

  cargoHash = "sha256-tcGyoPVoJFhbXZFe23d00Z7FUwIo5J02EfPTBzCGE64=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    vulkan-loader
    wayland
    libGL
    libxcursor
    libxi
    libx11
  ];

  preBuild = ''
    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.desktop \
        -t $out/share/applications
    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.metainfo.xml \
        -t $out/share/metainfo
    install -m 444 \
        -D $src/assets/icon/scalable.svg \
        $out/share/icons/hicolor/scalable/apps/io.github.dimtpap.coppwr.svg
    for size in 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      install -m 444 \
          -D $src/assets/icon/"$size".png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/io.github.dimtpap.coppwr.png
    done
  '';

  postFixup = ''
    patchelf $out/bin/coppwr \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  meta = {
    description = "Low level control GUI for the PipeWire multimedia server";
    homepage = "https://github.com/dimtpap/coppwr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ravenz46 ];
    mainProgram = "coppwr";
    platforms = lib.platforms.linux;
  };
})
