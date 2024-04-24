{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pipewire
, stdenv
, libGL
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "coppwr";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
    rev = version;
    hash = "sha256-azho/SVGEdHXt/t6VSA0NVVfhxK9bxy4Ud68faFh5zo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egui_node_graph-0.4.0" = "sha256-VJvALtPP/vPZQ4KLWu8diFar9vuVkbeD65Em6rod8ww=";
      "libspa-0.7.2" = "sha256-0TGhxHL1mkktE263ln3jnPZRkXS6+C3aPUBg86J25oM=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    libGL
    wayland
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
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
    patchelf $out/bin/${pname} \
      --add-rpath ${lib.makeLibraryPath [ libGL libxkbcommon wayland ]}
  '';

  meta = with lib; {
    description = "Low level control GUI for the PipeWire multimedia server";
    homepage = "https://github.com/dimtpap/coppwr";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ravenz46 ];
    platforms = platforms.linux;
    mainProgram = "coppwr";
  };
}
