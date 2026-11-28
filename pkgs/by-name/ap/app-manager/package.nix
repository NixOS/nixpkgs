{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  wayland-scanner,
  desktop-file-utils,
  wrapGAppsHook4,
  makeWrapper,
  gtk4,
  libadwaita,
  glib,
  glib-networking,
  json-glib,
  libgee,
  libsoup_3,
  libsecret,
  gnutls,
  libseccomp,
  wayland,
  squashfs-tools,
  squashfuse,
  dwarfs,
  zsync-rs,
  appimage-thumbnailer,
  bubblewrap,
  xdg-dbus-proxy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "app-manager";
  version = "4.0.0-beta7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kem-a";
    repo = "AppManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3RYtOu6xKpO/gkgvLbDmOi/7w1RV6R0+ZH/Z1CvyLoM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    wayland-scanner
    desktop-file-utils
    wrapGAppsHook4
    makeWrapper
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    glib-networking
    json-glib
    libgee
    libsoup_3
    libsecret
    gnutls
    # Sandbox hardening.
    libseccomp
    wayland
  ];

  mesonFlags = [
    # Use the tools packaged in nixpkgs instead of downloading/building copies.
    "-Dbundle_dwarfs=false"
    "-Dbundle_zsync=false"
    "-Dbundle_unsquashfs=false"
    "-Dbundle_squashfuse=false"
    # Build all optional sandbox hardening.
    "-Dseccomp=enabled"
    "-Dwayland_security_context=enabled"
  ];

  dontWrapGApps = true;

  # Expose appimage-thumbnailer's descriptor on app-manager's share directory;
  # the binary it points at lives inside the appimage-thumbnailer store path.
  postInstall = ''
    mkdir -p $out/share/thumbnailers
    ln -s ${appimage-thumbnailer}/share/thumbnailers/appimage-thumbnailer.thumbnailer \
      $out/share/thumbnailers/appimage-thumbnailer.thumbnailer
  '';

  postFixup = ''
    wrapProgram $out/bin/app-manager \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${
        lib.makeBinPath [
          squashfs-tools # unsquashfs
          squashfuse # squashfuse
          dwarfs # dwarfsextract, dwarfs
          zsync-rs # zsync-rs
          appimage-thumbnailer # appimage-thumbnailer
          bubblewrap # bwrap
          xdg-dbus-proxy # xdg-dbus-proxy
          gtk4 # gtk4-update-icon-cache
          desktop-file-utils # update-desktop-database
        ]
      }:/run/wrappers/bin"
  '';

  meta = {
    description = "AppImage installer and manager with a macOS-style drag-and-drop interface";
    homepage = "https://github.com/kem-a/AppManager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ MuntasirSZN ];
    platforms = lib.platforms.linux;
    mainProgram = "app-manager";
  };
})
