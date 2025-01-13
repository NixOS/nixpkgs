{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  glib,
  libgudev,
  ppp,
  gettext,
  pkg-config,
  libxslt,
  python3,
  libmbim,
  libqmi,
  bash-completion,
  meson,
  ninja,
  vala,
  dbus,
  bash,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  polkit,
  withPolkit ? lib.meta.availableOn stdenv.hostPlatform polkit,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation rec {
  pname = "modemmanager";
  version = "1.22.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "ModemManager";
    rev = version;
    hash = "sha256-/D9b2rCCUhpDCUfSNAWR65+3EyUywzFdH1R17eSKRDo=";
  };

  patches = [
    # Since /etc is the domain of NixOS, not Nix, we cannot install files there.
    # But these are just placeholders so we do not need to install them at all.
    ./no-dummy-dirs-in-sysconfdir.patch

    (fetchpatch {
      name = "GI_TYPELIB_PATH.patch";
      url = "https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/commit/daa829287894273879799a383ed4dc373c6111b0.patch";
      hash = "sha256-tPQokiZO2SpTlX8xMlkWjP1AIXgoLHW3rJwnmG33z/k=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs =
    [
      meson
      ninja
      gettext
      glib
      pkg-config
      libxslt
      python3
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
      vala
    ];

  buildInputs =
    [
      glib
      libgudev
      ppp
      libmbim
      libqmi
      bash-completion
      dbus
      bash # shebangs in share/ModemManager/fcc-unlock.available.d/
    ]
    ++ lib.optionals withPolkit [
      polkit
    ]
    ++ lib.optionals withSystemd [
      systemd
    ];

  nativeInstallCheckInputs = [
    python3
    python3.pkgs.dbus-python
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    "-Ddbus_policy_dir=${placeholder "out"}/share/dbus-1/system.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "qrtr" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "systemd_suspend_resume" withSystemd)
    (lib.mesonBool "systemd_journal" withSystemd)
    (lib.mesonOption "polkit" (if withPolkit then "strict" else "no"))
  ];

  postPatch = ''
    patchShebangs \
      tools/test-modemmanager-service.py
  '';

  # In Nixpkgs g-ir-scanner is patched to produce absolute paths, and
  # that interferes with ModemManager's tests, causing them to try to
  # load libraries from the install path, which doesn't usually exist
  # when `meson test' is run.  So to work around that, we run it as an
  # install check instead, when those paths will have been created.
  doInstallCheck = withIntrospection;
  installCheckPhase = ''
    runHook preInstallCheck
    export G_TEST_DBUS_DAEMON="${dbus}/bin/dbus-daemon"
    patchShebangs tools/tests/test-wrapper.sh
    mesonCheckPhase
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = licenses.gpl2Plus;
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
  };
}
