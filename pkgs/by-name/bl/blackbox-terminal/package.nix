{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  vte-gtk4,
  json-glib,
  sassc,
  libadwaita,
  pcre2,
  libxml2,
  librsvg,
  libgee,
  python3,
  desktop-file-utils,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackbox-terminal";
  version = "0.15.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LcJKbvEwXv47F1UYF5IF7b5K5o0ols77Q+HY0gQMy2c=";
  };

  postPatch = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    sassc
    wrapGAppsHook4
    python3
    desktop-file-utils # For update-desktop-database
  ];
  buildInputs = [
    gtk4
    vte-gtk4
    json-glib
    libadwaita
    pcre2
    libxml2
    librsvg
    libgee
  ];

  meta = {
    description = "Elegant and customizable terminal for GNOME";
    homepage = "https://gitlab.gnome.org/raggesilver/blackbox";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      chuangzhu
    ];
    mainProgram = "blackbox-terminal";
    platforms = lib.platforms.linux;
  };
})
