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
  version = "1.2.0-unstable-2025-10-11";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "ad266003aa74ddba1d22259b213a7f9c996e1cd4";
    sha256 = "OoJRkU4POW9RajwW05xYPlkodXqytq89GTbJuoLxebY=";
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

  meta = with lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
  };
}
