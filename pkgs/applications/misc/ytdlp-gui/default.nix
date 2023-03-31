{ lib
, fetchFromGitHub
, rustPlatform
, pkgs
}:

rustPlatform.buildRustPackage rec {
  pname = "ytdlp-gui";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "BKSalman";
    repo = "ytdlp-gui";
    rev = "v${version}";
    sha256 = "sha256-BB2zM0EIPYkv5tMX6TCXVkLoz7HQCXVMOiEEwPJRAB0=";
  };

  cargoSha256 = "sha256-1jvCcHDfMbVxsNI1iBngx8uEUkENeM7sbzSL0DgpK+o=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = with pkgs; [
    fontconfig

    vulkan-headers
    vulkan-loader
    libGL

    libxkbcommon
    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];

  postInstall = ''
    for _size in "16x16" "32x32" "48x48" "64x64" "128x128" "256x256"; do
        install -Dm644 "$src/data/icons/$_size/apps/ytdlp-gui.png" "$out/share/icons/hicolor/$_size/apps/ytdlp-gui.png"
    done
    install -Dm644 "$src/data/applications/ytdlp-gui.desktop" -t "$out/share/applications/"
  '';

  postFixup = ''
    wrapProgram $out/bin/ytdlp-gui \
      --prefix PATH : ${lib.makeBinPath [ pkgs.gnome.zenity pkgs.libsForQt5.kdialog]}\
      --suffix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}
  '';

  meta = with lib; {
    description = "A GUI for yt-dlp written in Rust";
    homepage = "https://github.com/bksalman/ytdlp-gui/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bksalman ];
  };
}
