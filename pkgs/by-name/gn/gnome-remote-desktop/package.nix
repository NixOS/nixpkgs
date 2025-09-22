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
  libva,
  vulkan-loader,
  shaderc,
  nv-codec-headers-11,
  pipewire,
  systemd,
  libsecret,
  libnotify,
  libopus,
  libxkbcommon,
  gdk-pixbuf,
  freerdp,
  fdk_aac,
  tpm2-tss,
  fuse3,
  gnome,
  polkit,
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "48.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-remote-desktop/${lib.versions.major version}/gnome-remote-desktop-${version}.tar.xz";
    hash = "sha256-vPN3D8oPrtovrjsaP/by6QoCd492pC6P0QPK4YYo9PI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    asciidoc
    shaderc # for glslc
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    freerdp
    fdk_aac
    tpm2-tss
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libei
    libepoxy
    libdrm
    libva
    vulkan-loader
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
    "-Dc_args=-I${freerdp}/include/winpr3"
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-remote-desktop"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop/-/blob/${version}/NEWS?ref_type=tags";
    description = "GNOME Remote Desktop server";
    mainProgram = "grdctl";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
