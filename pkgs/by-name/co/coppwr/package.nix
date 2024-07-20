{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pipewire
, libGL
, wayland
, xorg
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "coppwr";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
    rev = version;
    hash = "sha256-7z1b++itHoqVX5KB9gv6dMAzq1j7VDGYzuJArUDPlD4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egui_node_graph-0.4.0" = "sha256-VtHgKWh+bHSFltNgYaFmYhZW9tqwiWJjiCCspeKgSXQ=";
      "libspa-0.8.0" = "sha256-X8mwLtuPuMxZY71GNPAgiJGJ9JNMj7AbCliXiBxJ4vQ=";
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
    vulkan-loader
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
