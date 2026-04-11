{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  writeText,
  replaceVars,
  meson,
  pkg-config,
  ninja,
  docbook-xsl-nons,
  gettext,
  libxslt,
  gtk3,
  libdrm,
  libevdev,
  libpng,
  libxkbcommon,
  pango,
  systemd,
  xkeyboard-config,
  fontconfig,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plymouth";
  version = "24.004.60";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "plymouth";
    repo = "plymouth";
    rev = finalAttrs.version;
    hash = "sha256-9JmZCm8bjteJTQrMSJeL4x2CAI6RpKowFUDSCcMS4MM=";
  };

  patches = [
    # do not create unnecessary symlink to non-existent header-image.png
    ./dont-create-broken-symlink.patch
    # add support for loading plugins from /run to assist NixOS module
    ./add-runtime-plugin-path.patch
    # fix FHS hardcoded paths
    (replaceVars ./fix-paths.patch {
      fcmatch = "${fontconfig}/bin/fc-match";
    })

    # fix build without udev, see https://gitlab.freedesktop.org/plymouth/plymouth/-/merge_requests/382 - drop on next release
    (fetchpatch {
      name = "fix-build-without-udev.patch";
      url = "https://gitlab.freedesktop.org/plymouth/plymouth/-/commit/f1ce78764482699b28f60c89af1a071ea0ae13ca.patch";
      hash = "sha256-t5xt/scO8mVwESU8pFPTSXILd0FhmG/XRZ8O/4baQB8=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    docbook-xsl-nons
    gettext
    libxslt
  ];

  buildInputs = [
    gtk3
    libdrm
    libevdev
    libpng
    libxkbcommon
    pango
    xkeyboard-config
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ];

  mesonFlags =
    let
      # https://gitlab.freedesktop.org/plymouth/plymouth/-/blob/a5eda165689864cc9a25ec14fd8c6da458598f42/meson.build#L47
      crossFile = writeText "cross-file.conf" ''
        [binaries]
        systemd-tty-ask-password-agent = '${lib.getBin systemd}/bin/systemd-tty-ask-password-agent'
      '';
    in
    [
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "-Dlogo=/etc/plymouth/logo.png"
      "-Dbackground-color=0x000000"
      "-Dbackground-start-color-stop=0x000000"
      "-Dbackground-end-color-stop=0x000000"
      "-Drelease-file=/etc/os-release"
      "-Dudev=${if systemdSupport then "enabled" else "disabled"}"
      "-Drunstatedir=/run"
      "-Druntime-plugins=true"
      "-Dsystemd-integration=${lib.boolToString systemdSupport}"
    ]
    ++ lib.optionals systemdSupport [
      "--cross-file=${crossFile}"
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "run_command(['scripts/generate-version.sh'], check: true).stdout().strip()" "'${finalAttrs.version}'"

    # prevent installing unused non-$out dirs to DESTDIR
    sed -i '/^install_emptydir/d' src/meson.build
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    cp -a "$DESTDIR/etc" "$out"
    rm -r "$DESTDIR/etc"
    for o in $(getAllOutputNames); do
        if [[ "$o" = "debug" ]]; then continue; fi
        cp -a "$DESTDIR/''${!o}" "$(dirname "''${!o}")"
        rm -r "$DESTDIR/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    rmdir "$DESTDIR/${builtins.storeDir}" "$DESTDIR/${dirOf builtins.storeDir}" "$DESTDIR"
  '';

  # HACK: We want to install configuration files to $out/etc
  # but Plymouth should read them from /etc on a NixOS system.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  env.DESTDIR = "${placeholder "out"}/dest";

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
