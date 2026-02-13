{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  gtk-layer-shell,
  cairo,
  atk,
  pango,
  harfbuzz,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "rumno";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    rev = "89b3df9f1e1a00418b2bf41f6de392956f1425b5";
    hash = "sha256-vR6+dNq0sdVtzdBL6GTzqAhl0fE6ulF6UCqIH1fSte4=";
  };

  cargoHash = "sha256-1FyDMdOO7m6y2oX/+VH5LxBwimz7fXM59eOeiffBnOI=";

  # rumno-background uses daemonize and sets an overly restrictive umask (0o777),
  # resulting in an unreadable/unwritable PID file under /tmp/rumno.
  postPatch = ''
    substituteInPlace src/common/daemon.rs \
      --replace-fail "        .umask(0o777)" "        .umask(0o077)"

    # Under Wayland (wlroots compositors), rumno uses layer-shell. The upstream default anchored
    # the surface to the top edge; for volume/brightness OSD we want it centered.
    substituteInPlace src/ui/app.rs \
      --replace-fail "            window.set_anchor(Edge::Top, true);" "            window.set_anchor(Edge::Top, false);" \
      --replace-fail "            window.set_layer_shell_margin(Edge::Top, 60);" "            window.set_layer_shell_margin(Edge::Top, 0);"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk3
    gtk-layer-shell
    cairo
    atk
    pango
    harfbuzz
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual pop-up notification manager";
    homepage = "https://gitlab.com/ivanmalison/rumno";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "rumno";
    platforms = lib.platforms.linux;
  };
}
