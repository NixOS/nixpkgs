{
  lib,
  stdenv,
  fetchFromGitHub,
  adwaita-qt,
  libadwaita,
  adw-gtk3,
  gst_all_1,
  gnome-themes-extra,
  librsvg,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qqsp";
  version = "1.9";
  src = fetchFromGitHub {
    owner = "Sonnix1";
    repo = "Qqsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eDgoa+/dcJ8Ti+YLHgKUKus0+zRrFEuJ19wUpbFpcBU=";
  };
  buildInputs = [
    adwaita-qt
    libadwaita
    adw-gtk3
    gnome-themes-extra
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    qt5.qtmultimedia
    qt5.qtwebengine
    qt5.qtbase
  ];
  nativeBuildInputs = [
    qt5.qmake
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtwebengine
    qt5.wrapQtAppsHook
    librsvg
  ];
  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";
  installPhase = ''
    install -D Qqsp $out/bin/Qqsp
    install -D $src/icons/qsp-logo-vector.svg $out/icons/scalable/apps/qsp.svg
    install -D $src/Qqsp.desktop $out/share/applications/Qqsp.desktop
    install -D $src/qsp.mime $out/share/mime/packages/qsp.xml
    for i in 16 24 32 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/''${i}x$i/apps
      rsvg-convert -w $i -h $i -f png $src/icons/qsp-logo-vector.svg -o $out/share/icons/''${i}x$i/apps/qsp.png
    done
  '';
  meta = {
    description = "Qt Quest Soft Player";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/Sonnix1/Qqsp";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "Qqsp";
    maintainers = [ lib.maintainers.JohnMolotov ];
  };
})
