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
<<<<<<< HEAD
  version = "1.2.0-unstable-2025-12-22";
=======
  version = "1.2.0-unstable-2025-10-11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
<<<<<<< HEAD
    rev = "c329a1fc2be59a6094ef7f7b1fe5fd92f73947a4";
    sha256 = "mE7Hzvh3mZKwcVPeVlB8jWcTRp3sDLe0zr0l6kaUEo8=";
=======
    rev = "ad266003aa74ddba1d22259b213a7f9c996e1cd4";
    sha256 = "OoJRkU4POW9RajwW05xYPlkodXqytq89GTbJuoLxebY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
