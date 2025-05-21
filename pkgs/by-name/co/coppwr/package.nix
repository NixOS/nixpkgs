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
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
    rev = version;
    hash = "sha256-Wit0adP9M8vlCXF6WJx2tZnR6LrwcvoTNx1KC1HfN8w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tgvSOwZmboe4DzEqJOCYWwIbAStGV1F6ZAzlwCd7Uo4=";

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
