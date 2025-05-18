{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  glib,
  meson,
  ninja,
  pkg-config,
  python3,
  coreutils,
  gnome-desktop,
  gnupg,
  gtk3,
  systemdMinimal,
  udisks,
}:

stdenv.mkDerivation rec {
  pname = "eos-installer";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "endlessm";
    repo = "eos-installer";
    rev = "Release_${version}";
    sha256 = "BqvZglzFJabGXkI8hnLiw1r+CvM7kSKQPj8IKYBB6S4=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    glib
    gnupg
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [
    gnome-desktop
    gtk3
    systemdMinimal
    udisks
  ];

  preConfigure = ''
    patchShebangs tests
    substituteInPlace tests/test-scribe.c \
        --replace /bin/true ${coreutils}/bin/true \
        --replace /bin/false ${coreutils}/bin/false
  '';

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/bin"
    "--cross-file=${writeText "crossfile.ini" ''
      [binaries]
      gpg = '${gnupg}/bin/gpg'
    ''}"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/endlessm/eos-installer";
    description = "Installer UI which writes images to disk";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
    mainProgram = "gnome-image-installer";
    platforms = platforms.linux;
  };
}
