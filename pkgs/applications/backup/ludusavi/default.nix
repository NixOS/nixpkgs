{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, bzip2
, fontconfig
, freetype
, libGL
, libX11
, libXcursor
, libXrandr
, libXi
, libxkbcommon
, vulkan-loader
, wayland
, gnome
, libsForQt5
}:

rustPlatform.buildRustPackage rec {
  pname = "ludusavi";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "ludusavi";
    rev = "v${version}";
    hash = "sha256-3Z/v3+3mrmPV2Rb/5tM+h6UN+MEIF/aK07B93Zn38AA=";
  };

  cargoHash = "sha256-bAap8eSXAPLrs5MEX1Pp6gKdp0iLxci4aX+2+ve6Wk0=";

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    libX11
    libXcursor
    libXrandr
    libXi
  ];

  postInstall = ''
    install -Dm644 assets/com.github.mtkennerly.ludusavi.metainfo.xml -t \
      "$out/share/metainfo/"
    install -Dm644 assets/icon.png \
      "$out/share/icons/hicolor/64x64/apps/ludusavi.png"
    install -Dm644 assets/icon.svg \
      "$out/share/icons/hicolor/scalable/apps/ludusavi.svg"
    install -Dm644 "assets/ludusavi.desktop" -t "$out/share/applications/"
    install -Dm644 assets/MaterialIcons-Regular.ttf -t "$out/share/fonts/TTF/"
    install -Dm644 LICENSE -t "$out/share/licenses/ludusavi/"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        bzip2
        fontconfig
        freetype
        libX11
        libXcursor
        libXrandr
        libXi
        libxkbcommon
        vulkan-loader
        wayland
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/ludusavi"
      wrapProgram $out/bin/ludusavi --prefix PATH : ${lib.makeBinPath [ gnome.zenity libsForQt5.kdialog ]}
    '';


  meta = with lib; {
    description = "Backup tool for PC game saves";
    homepage = "https://github.com/mtkennerly/ludusavi";
    changelog = "https://github.com/mtkennerly/ludusavi/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pasqui23 ];
    mainProgram = "ludusavi";
  };
}
