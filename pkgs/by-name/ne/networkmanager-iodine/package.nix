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
  version = "1.2.0-unstable-2024-11-02";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "dd633f80913ae637d6f496bae1b7bac8c297860c";
    sha256 = "sAndI8jjCcRENDGz4V3AKswybzC8PDzYPaEN1mLcti8=";
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

  buildInputs =
    [
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
    "--with-gnome=${if withGnome then "yes" else "no"}"
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
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
