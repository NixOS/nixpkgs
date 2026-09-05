{
  atk,
  cairo,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gnome-settings-daemon,
  gnome-shell,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libhandy,
  mutter,
  pango,
  phoc,
  phosh,
  pkg-config,
  rustPlatform,
  wayland,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phrog";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "samcday";
    repo = "phrog";
    tag = finalAttrs.version;
    hash = "sha256-ojr5k6eYONMNDk/DwWU6RxCDv9TrnUskFqL+2X0DIT0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-0iUemQZzXLu6VfTKj+ov7DZH3u/6aiQziTKok3E0SXg=";

  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook3
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gnome-settings-daemon
    gsettings-desktop-schemas
    gtk3
    libhandy
    mutter
    pango
    phoc
    # libphosh-0.45.pc, from phosh's -Dbindings-lib=true.
    phosh
    wayland
  ];

  # The suite needs a live phoc, a session bus and accountsservice.
  doCheck = false;

  # org.gnome.shell.keybindings; gnome-shell is schemas-only here
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath gnome-shell}"
    )
  '';

  postInstall = ''
    install -Dm644 -t "$out/share/glib-2.0/schemas" \
      data/mobi.phosh.phrog.gschema.xml
    glib-compile-schemas "$out/share/glib-2.0/schemas"

    install -Dm644 -t "$out/share/applications" data/mobi.phosh.Phrog.desktop
    install -Dm644 -t "$out/share/gnome-session/sessions" data/phrog.session
    install -Dm644 -t "$out/share/systemd/user" \
      data/mobi.phosh.Phrog.service \
      data/mobi.phosh.Phrog.target
    install -Dm644 data/systemd-session.conf \
      "$out/share/systemd/user/gnome-session@phrog.target.d/session.conf"
  '';

  meta = {
    description = "Mobile-friendly greeter for greetd, built on Phosh";
    maintainers = with lib.maintainers; [ marcusramberg ];
    homepage = "https://github.com/samcday/phrog";
    changelog = "https://github.com/samcday/phrog/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "phrog";
  };
})
