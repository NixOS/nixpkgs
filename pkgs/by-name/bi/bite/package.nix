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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bite";
  version = "0.43";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WINSDK";
    repo = "bite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-akwkTV1bZJ3GcEtObyF+qN5IkBRoXdztUSOghjQy7A0=";
  };

  cargoHash = "sha256-OlxUHYTbljWGWdiceBmW3J0oB4w0/5izgNnwCafV6xY=";

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
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.runtimeDependencies}"

    mkdir -p $out/share/icons/hicolor/64x64/apps
    magick $src/assets/iconx64.png -background black -alpha remove -alpha off $out/share/icons/hicolor/64x64/apps/bite.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "BiTE";
      exec = finalAttrs.meta.mainProgram;
      icon = "bite";
      desktopName = "BiTE";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Disassembler focused on comprehensive rust support";
    homepage = "https://github.com/WINSDK/bite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vinnymeller
      kybe236
    ];
    mainProgram = "bite";
  };
})
