{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
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
, zenity
, libsForQt5
}:

rustPlatform.buildRustPackage rec {
  pname = "ludusavi";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "ludusavi";
    rev = "v${version}";
    hash = "sha256-FtLLj5uFcKuRTCSsSuyj0XGzFMVWQvVk4dTmBCmzfNs=";
  };

  cargoHash = "sha256-xC6HiXt8cfrDtno9IrOe8SP7WBL79paLI223fjxPsbg=";

  nativeBuildInputs = [
    cmake
    installShellFiles
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
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ludusavi \
      --bash <($out/bin/ludusavi complete bash) \
      --fish <($out/bin/ludusavi complete fish) \
      --zsh <($out/bin/ludusavi complete zsh)
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
      wrapProgram $out/bin/ludusavi --prefix PATH : ${lib.makeBinPath [ zenity libsForQt5.kdialog ]}
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
