{
  stdenv,
  lib,
  meson,
  glib,
  gtk4,
  libsoup_3,
  gjs,
  desktop-file-utils,
  ninja,
  gobject-introspection,
  libadwaita,
  wrapGAppsHook4,
  glib-networking,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mensa-sh";
  version = "0.1.4";
  strictDeps = true;
  nativeBuildInputs = [
    meson
    glib
    desktop-file-utils
    ninja
    gobject-introspection
    wrapGAppsHook4
  ];
  buildInputs = [
    gtk4
    libadwaita
    libsoup_3
    glib-networking
  ];

  postPatch = ''
    substituteInPlace ./src/meson.build \
      --replace-fail "bin_conf.set('GJS', find_program('gjs').full_path())" \
      "bin_conf.set('GJS', '${lib.getExe gjs}')"
  '';

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    ln -s $out/share/mensa-sh/digital.fischers.mensash.src.gresource \
          $out/share/mensa-sh/mensa-sh.src.gresource
    ln -s $out/share/mensa-sh/digital.fischers.mensash.data.gresource \
          $out/share/mensa-sh/mensa-sh.data.gresource
    ln -s $out/bin/digital.fischers.mensash \
          $out/bin/mensa-sh
  '';
  src = fetchFromGitHub {
    owner = "importantus";
    repo = "mensa-sh-gnome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8LZWm0zxltuDqdu6TPHB+QoZbvXQNFqMT7C8lkdCDdQ=";
  };

  meta = {
    homepage = "https://github.com/importantus/mensa-sh-gnome";
    description = "GTK4/Libadwaita client for the menus of the canteens and cafeterias in Schleswig-Holstein";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lomenzel ];
  };
})
