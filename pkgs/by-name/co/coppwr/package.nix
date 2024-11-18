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
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "coppwr";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
    rev = version;
    hash = "sha256-5TgK/0UN05P3WENch4sBo/Sy9FaMmyH/gZ+6qUyM1z0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xF/eBBXlbOfGy9avDkOXT/q72DHJ7Zlu3lfDsTwo+3U=";

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
    xorg.libXcursor
    xorg.libXi
    xorg.libX11
  ];

  preBuild = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,metainfo}

    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.desktop \
        -t $out/share/applications
    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.metainfo.xml \
        -t $out/share/metainfo
    cp $src/assets/icon/scalable.svg $out/share/icons/hicolor/scalable/apps/io.github.dimtpap.coppwr.svg
    for size in 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      cp $src/assets/icon/"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/io.github.dimtpap.coppwr.png
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
}
