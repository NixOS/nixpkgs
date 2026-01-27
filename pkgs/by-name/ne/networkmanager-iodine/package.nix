{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  autoreconfHook,
  iodine,
  intltool,
  pkg-config,
  networkmanager,
  libsecret,
  gtk3,
  withGnome ? true,
  unstableGitUpdater,
  libnma,
  glib,
}:

stdenv.mkDerivation {
  pname = "NetworkManager-iodine${lib.optionalString withGnome "-gnome"}";
  version = "1.2.0-unstable-2026-01-06";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "f4c176eb42a8b332d650d2e1704a4c397d69f17c";
    sha256 = "rFO0EIsMNI3NvdKSJxRP29l4R5JG0rtJntd2fP+UZMw=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit iodine;
    })
  ];

  nativeBuildInputs = [
    intltool
    autoreconfHook
    pkg-config
    glib
  ];

  buildInputs = [
    iodine
    networkmanager
    glib
  ]
  ++ lib.optionals withGnome [
    gtk3
    libsecret
    libnma
  ];

  configureFlags = [
    "--with-gnome=${lib.boolToYesNo withGnome}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  preConfigure = ''
    intltoolize
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };

    networkManagerPlugin = "VPN/nm-iodine-service.name";
  };

  meta = {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = lib.licenses.gpl2Plus;
  };
}
