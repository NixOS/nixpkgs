{ lib
, mkDerivation
, fetchFromGitHub
, writeText

, cmake
, pkg-config

, qttools
, qca-qt5
, lzo
, openldap
, cyrus_sasl
, pam
, procps
, libXtst
, libXrandr
, libXinerama
, libXdamage
, libXcursor
, libvncserver
, libfakekey
}:

let
  version = "4.8.2";

  contributors = writeText "veyon-CONTRIBUTORS" ''
    Tobias Junghans
    For more see: https://github.com/veyon/veyon/contributors
  '';
in
mkDerivation {
  pname = "veyon";
  inherit version;

  src = fetchFromGitHub {
    owner = "veyon";
    repo = "veyon";
    rev = "v${version}";
    hash = "sha256-QU0bMR1QmrSFOalXOQJgwzVhoaWAHyQ0D90g0/oyl5Q=";
    fetchSubmodules = true; # kldap, x11vnc and qthttpserver get built from source
  };

  patches = [ ./fix-install-perms.patch ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    # cmake's setup hook makes it so that this is absolute by default
    # veyon's build steps only work if this is relative
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DSYSTEMD_SERVICE_INSTALL_DIR=lib/systemd/system"
    "-DCONTRIBUTORS=${contributors}"
  ];

  buildInputs = [
    qttools
    qca-qt5
    lzo
    openldap
    cyrus_sasl
    pam
    procps
    libXtst
    libXrandr
    libXinerama
    libXdamage
    libXcursor
    libvncserver
    libfakekey
  ];

  # Some executables need to access the other ones
  qtWrapperArgs = [ "--prefix PATH : ${placeholder "out"}/bin" ];

  meta = {
    changelog = "https://github.com/veyon/veyon/releases/tag/v${version}";
    description = "A free and open source software for monitoring and controlling computers across multiple platforms";
    homepage = "https://veyon.io";
    license = lib.licenses.gpl2Only;
    mainProgram = "veyon-master";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
}
