{
  asciidoc,
  cairo,
  dbus,
  fdk_aac,
  fetchurl,
  freerdp3,
  fuse3,
  gdk-pixbuf,
  glib,
  gnome,
  lib,
  libdrm,
  libei,
  libepoxy,
  libgudev,
  libnotify,
  libopus,
  libsecret,
  libxkbcommon,
  mesa,
  meson,
  mutter,
  ninja,
  nv-codec-headers-11,
  openssl,
  pipewire,
  pkg-config,
  polkit,
  python3,
  stdenv,
  systemd,
  tpm2-tss,
  wireplumber,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "47.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-remote-desktop/${lib.versions.major version}/gnome-remote-desktop-${version}.tar.xz";
    hash = "sha256-QE2wiHLmkDlD4nUam2Myf2NZcKnKodL2dTCcpEV8+cI=";
  };

  postPatch = ''
    patchShebangs \
      tests/prepare-test-environment.sh \
      tests/run-vnc-tests.py

    substituteInPlace tests/prepare-test-environment.sh \
      --replace-fail \
        dbus_run_session=\$\{DBUS_RUN_SESSION_BIN:-dbus-run-session\} \
        'dbus_run_session="dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf"'
  '';

  nativeBuildInputs = [
    asciidoc
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    fdk_aac
    freerdp3
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libdrm
    libei
    libepoxy
    libnotify
    libopus
    libsecret
    libxkbcommon
    nv-codec-headers-11
    pipewire
    polkit # For polkit-gobject
    systemd
    tpm2-tss
  ] ++ lib.optional doCheck checkInputs;

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    # TODO: investigate who should be fixed here.
    "-Dc_args=-I${freerdp3}/include/winpr3"
  ];

  doCheck = true;

  checkInputs = [
    dbus # for dbus-run-session
    libgudev
    mesa # for gbm
    mutter
    openssl
    wireplumber
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
