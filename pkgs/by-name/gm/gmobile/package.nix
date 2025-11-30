{
  lib,
  stdenv,
  fetchFromGitLab,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  libuev,
  gobject-introspection,
  udevCheckHook,
  vala,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmobile";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "gmobile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VBtZU3AM+Off8bHYyW50y3+PY9u7D+xzChlnBlae+ns=";
  };

  nativeBuildInputs = [
    gtk-doc
    meson
    ninja
    pkg-config
    gobject-introspection
    udevCheckHook
    vala
  ];

  buildInputs = [
    glib
    json-glib
    libuev
  ];

  doInstallCheck = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Functions useful in mobile related, glib based projects";
    homepage = "https://gitlab.gnome.org/World/Phosh/gmobile";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      donovanglover
      armelclo
    ];
    platforms = lib.platforms.linux;
  };
})
