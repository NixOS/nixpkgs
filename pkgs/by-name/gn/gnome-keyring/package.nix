{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  dbus,
  libgcrypt,
  pam,
  glib,
  libxslt,
  gettext,
  gcr_3,
  libcap_ng,
  libselinux,
  p11-kit,
  systemdLibs,
  wrapGAppsNoGuiHook,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gnome,
  nixosTests,
  useWrappedDaemon ? true,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-keyring";
  version = "51.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.major finalAttrs.version}/gnome-keyring-${finalAttrs.version}.tar.xz";
    hash = "sha256-3+etxYdu8GcOfropB3mb27iHXOWLtCCOGlIWm9FqR8o=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    glib # for glib-genmarshal
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    libgcrypt
    pam
    libcap_ng
    libselinux
    gcr_3
    p11-kit
  ]
  ++ lib.optionals withSystemd [
    systemdLibs
  ];

  nativeCheckInputs = [ dbus ];

  mesonFlags = [
    # installation directories
    "-Dpkcs11-config=${placeholder "out"}/etc/pkcs11" # todo: this should probably be /share/p11-kit/modules
    "-Dpkcs11-modules=${placeholder "out"}/lib/pkcs11"
    (lib.mesonEnable "systemd" withSystemd)
  ];

  doCheck = true;
  strictDeps = true;

  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    # The import test races its own teardown and aborts under load.
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs --exclude gnome-keyring:import

    runHook postCheck
  '';

  postFixup =
    # disable OnlyShowIn to allow xdg-autostart in any DE
    # https://wiki.archlinux.org/title/GNOME/Keyring#Using_gnome-keyring-daemon_outside_desktop_environments_(KDE,_GNOME,_XFCE,_...)
    ''
      for f in "$out"/etc/xdg/autostart/*.desktop; do
        [ -e "$f" ] || continue
        substituteInPlace "$f" \
          --replace-fail "OnlyShowIn=" "#OnlyShowIn="
      done
    ''
    # Use wrapped gnome-keyring-daemon with cap_ipc_lock=ep
    + lib.optionalString useWrappedDaemon ''
      files=(
        $out/etc/xdg/autostart/*
        $out/share/dbus-1/services/*
        ${lib.optionalString withSystemd "$out/share/systemd/user/gnome-keyring-daemon.service"}
      )

      for file in "''${files[@]}"; do
        substituteInPlace "$file" \
          --replace-fail "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
      done
    '';

  passthru = {
    tests = {
      inherit (nixosTests) gnome-keyring;
    };
    updateScript = gnome.updateScript {
      packageName = "gnome-keyring";
    };
  };

  meta = {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keyring";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = [
      # Most of the code (some is 2Plus)
      lib.licenses.lgpl21Plus
      # Some stragglers
      lib.licenses.gpl2Plus
    ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
