{
  lib,
  apple-sdk_15,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libxkbcommon,
  pango,
  vulkan-loader,
  stdenv,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "bite";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "WINSDK";
    repo = "bite";
    rev = "V${version}";
    hash = "sha256-gio4J+V8achSuR2vQa2dnvOR/u4Zbb5z0UE0xP0gGCU=";
  };

  cargoHash = "sha256-ESGX1hnDnU2taKQXre4AQRzQxTC7W+0cEIoQPPC9Lfs=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libxkbcommon
    pango
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  runtimeDependencies = [
    libxkbcommon
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  postInstall = ''
    wrapProgram $out/bin/bite \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}"

    mkdir -p $out/share/icons/hicolor/64x64/apps
    convert $src/assets/iconx64.png -background black -alpha remove -alpha off $out/share/icons/hicolor/64x64/apps/bite.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "BiTE";
      exec = meta.mainProgram;
      icon = "bite";
      desktopName = "BiTE";
      comment = meta.description;
      categories = [
        "Development"
        "Utility"
      ];
    })
  ];

  meta = with lib; {
    description = "Disassembler focused on comprehensive rust support";
    homepage = "https://github.com/WINSDK/bite";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "bite";
  };
}
