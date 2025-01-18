{
  lib,
  stdenv,
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
  pname = "concessio";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "ronniedroid";
    repo = "concessio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XH+4oEZSKa6lAS0zXxdlCsVJcGDglKSgaD+zoRM6Pws=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    gjs
    glib # For `glib-compile-schema`
    gobject-introspection
    gtk4 # For `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    libadwaita
  ];

  # gjs uses the invocation name to add gresource files
  # to get around this, we set the entry point name manually
  preFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'io.github.ronniedroid.concessio';" $out/bin/io.github.ronniedroid.concessio
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Understand File Permissions";
    homepage = "https://github.com/ronniedroid/concessio";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ getchoo ];
    mainProgram = "io.github.ronniedroid.concessio";
    platforms = intersectLists platforms.linux gjs.meta.platforms;
  };
})
