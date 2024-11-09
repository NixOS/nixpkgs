{
  stdenv,
  lib,
  fetchurl,
  cairo,
  meson,
  ninja,
  pkg-config,
  python3,
  asciidoc,
  wrapGAppsHook3,
  glib,
  libei,
  libepoxy,
  libdrm,
  nv-codec-headers-11,
  pipewire,
  systemd,
  libsecret,
  libnotify,
  libopus,
  libxkbcommon,
  gdk-pixbuf,
  freerdp3,
  fdk_aac,
  tpm2-tss,
  fuse3,
  gnome,
  polkit,
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-remote-desktop/${lib.versions.major version}/gnome-remote-desktop-${version}.tar.xz";
    hash = "sha256-iqVXdXV7KZ3r5Bfhaebij+y/GM5hHtF2+g1lCrU0R3Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    asciidoc
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    freerdp3
    fdk_aac
    tpm2-tss
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libei
    libepoxy
    libdrm
    nv-codec-headers-11
    libnotify
    libopus
    libsecret
    libxkbcommon
    pipewire
    systemd
    polkit # For polkit-gobject
  ];

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dtests=false" # Too deep of a rabbit hole.
    # TODO: investigate who should be fixed here.
    "-Dc_args=-I${freerdp3}/include/winpr3"
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-remote-desktop"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop/-/blob/${version}/NEWS?ref_type=tags";
    description = "GNOME Remote Desktop server";
    mainProgram = "grdctl";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
