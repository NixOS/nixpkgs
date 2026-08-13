{
  lib,
  fetchFromGitHub,
  wrapGAppsHook3,
  buildGoModule,
  glib,
  pkg-config,
  cairo,
  gtk3,
  xcur2png,
  libx11,
  zlib,
}:

buildGoModule (finalAttrs: {
  pname = "nwg-look";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-look";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YAFZZIUd/nvDwa3dXBoBL+dmPOVgJKv/taOjLMP4owI=";
  };

  vendorHash = "sha256-9jyR7RLpqdDvwgqlrvToKQlClRbk9ELxapbgb/OUB4I=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    cairo
    xcur2png
    libx11.dev
    zlib
    gtk3
  ];

  env.CGO_ENABLED = 1;

  postInstall = ''
    mkdir -p $out/share/nwg-look/langs
    cp stuff/main.glade $out/share/nwg-look/
    cp langs/* $out/share/nwg-look/langs
    install -D -m 644 stuff/nwg-look.desktop -t $out/share/applications
    install -D -m 644 stuff/nwg-look.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${glib.bin}/bin"
      --prefix PATH : "${xcur2png}/bin"
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-look";
    description = "GTK settings editor, designed to work properly in wlroots-based Wayland environment";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ max-amb ];
    mainProgram = "nwg-look";
  };
})
