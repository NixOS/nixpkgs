{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  makeWrapper,
  wrapGAppsHook3,
  bzip2,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libxkbcommon,
  vulkan-loader,
  wayland,
  zenity,
  libsForQt5,
  cairo,
  pango,
  atkmm,
  gdk-pixbuf,
  dbus-glib,
  gtk3,
  glib,
}:

rustPlatform.buildRustPackage rec {
  pname = "ludusavi";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "ludusavi";
    rev = "v${version}";
    hash = "sha256-+6/hpOFyAdYxh+HkOlc85utqIY4s4gyZoVQxin9hbkU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9ki6/KDoa1yLg7mZS7tB7ZjjiZIWOne4Ol7fIK4YPSo=";

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    fontconfig
    freetype
    libX11
    libXcursor
    libXrandr
    libXi
    cairo
    pango
    atkmm
    gdk-pixbuf
    gtk3
  ];

  postInstall =
    ''
      install -Dm644 assets/linux/com.mtkennerly.ludusavi.metainfo.xml -t \
        "$out/share/metainfo/"
      install -Dm644 assets/icon.png \
        "$out/share/icons/hicolor/64x64/apps/com.mtkennerly.ludusavi.png"
      install -Dm644 assets/icon.svg \
        "$out/share/icons/hicolor/scalable/apps/com.mtkennerly.ludusavi.svg"
      install -Dm644 "assets/linux/com.mtkennerly.ludusavi.desktop" -t "$out/share/applications/"
      install -Dm644 assets/MaterialIcons-Regular.ttf -t "$out/share/fonts/TTF/"
      install -Dm644 LICENSE -t "$out/share/licenses/ludusavi/"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
        gtk3
        dbus-glib
        glib
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/ludusavi"
      wrapProgram $out/bin/ludusavi --prefix PATH : ${
        lib.makeBinPath [
          zenity
          libsForQt5.kdialog
        ]
      } \
        "''${gappsWrapperArgs[@]}"
    '';

  meta = with lib; {
    description = "Backup tool for PC game saves";
    homepage = "https://github.com/mtkennerly/ludusavi";
    changelog = "https://github.com/mtkennerly/ludusavi/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      pasqui23
      megheaiulian
    ];
    mainProgram = "ludusavi";
  };
}
