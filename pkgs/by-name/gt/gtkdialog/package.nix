{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  gtk3,
  gtk-layer-shell,
  meson,
  ninja,
  pkg-config,
  vte,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkdialog";
  version = "0.8.5e";

  src = fetchFromGitHub {
    owner = "puppylinux-woof-CE";
    repo = "gtkdialog";
    tag = finalAttrs.version;
    hash = "sha256-VaKyR7KJOAHzZ3YrTVDN7DssRNQeWhZExiY79eEZNP4=";
  };

  nativeBuildInputs = [
    bison
    flex
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    vte
  ];

  mesonFlags = [ (lib.mesonBool "docs" true) ];

  # make it a little bit easier to run examples
  postInstall = ''
    find $out/share/doc/examples -type f -exec sed -i "s|GTKDIALOG=gtkdialog|GTKDIALOG=$out/bin/gtkdialog|g" {} +
  '';

  meta = {
    homepage = "https://github.com/puppylinux-woof-CE/gtkdialog";
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    mainProgram = "gtkdialog";
    maintainers = with lib.maintainers; [ aleksana ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
