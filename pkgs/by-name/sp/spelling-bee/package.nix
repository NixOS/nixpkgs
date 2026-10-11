{
  lib,
  stdenv,
  appstream,
  desktop-file-utils,
  fetchFromGitHub,
  gjs,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spelling-bee";
  version = "0.1.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "josephmawa";
    repo = "SpellingBee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZV6N4a67wW41yXCDO7WHq37rdG2W7wFc+9fXEPxn2Lc=";
  };

  # GJS uses programInvocationName basename to find the gresource files
  # (`<name>.src.gresource`, `<name>.data.gresource`). wrapGAppsHook4 renames
  # the wrapped binary to `.<name>-wrapped`, which breaks the lookup.
  # Override _findEffectiveEntryPointName so the original name is used.
  postPatch = ''
    sed -i "/^imports.package.init/i imports.package._findEffectiveEntryPointName = () => 'io.github.josephmawa.SpellingBee';" \
      src/bin/io.github.josephmawa.SpellingBee.in
  '';

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gjs
    glib
    gobject-introspection
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    glib
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Word puzzle game for building English vocabulary";
    homepage = "https://github.com/josephmawa/SpellingBee";
    changelog = "https://github.com/josephmawa/SpellingBee/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "io.github.josephmawa.SpellingBee";
    maintainers = with lib.maintainers; [ _3nln ];
    platforms = lib.platforms.linux;
  };
})
