{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  desktop-file-utils,
  appstream-glib,
  gjs,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  libportal,
  meson,
  ninja,
  wrapGAppsHook4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bella";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "josephmawa";
    repo = "Bella";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ePzDnaoGPa5Hku7Rpced989QB6uOXN/jfXgTwtlE7rQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils # `desktop-file-validate`, `update-desktop-database`
    appstream-glib # `appstream-util`
    gjs
    glib # `glib-compile-schemas`
    gobject-introspection
    gtk4 # `gtk4-update-icon-cache`
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libportal
  ];

  # GJS uses argv[0] to find gresource files, and wrappers will cause that mechanism to fail.
  # Manually overriding the entrypoint name should do the job.
  #
  # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L159
  # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L37
  preFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'io.github.josephmawa.Bella';" $out/bin/io.github.josephmawa.Bella
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple eye dropper and color picker";
    homepage = "https://github.com/josephmawa/Bella";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "io.github.josephmawa.Bella";
    platforms = lib.lists.intersectLists lib.platforms.linux gjs.meta.platforms;
  };
})
