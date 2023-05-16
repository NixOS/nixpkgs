{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, pcsclite, qtsvg, qttools, qtwebsockets
, qtquickcontrols2, qtgraphicaleffects }:

mkDerivation rec {
  pname = "AusweisApp2";
<<<<<<< HEAD
  version = "1.26.7";
=======
  version = "1.26.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-i9hfmMp0pEqtIeKc1mcyINXetzD/33aM0utL8nomVcg=";
=======
    hash = "sha256-l/sPqXkr4rSMEbPi/ahl/74RYqNrjcb28v6/scDrh1w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config ];

<<<<<<< HEAD
  # The build scripts copy the entire translations directory from Qt
  # which ends up being read-only because it's in the store.
  preBuild = ''
    chmod +w resources/translations
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ qtsvg qttools qtwebsockets qtquickcontrols2 qtgraphicaleffects pcsclite ];

  meta = with lib; {
    description = "Authentication software for the German ID card";
    downloadPage = "https://github.com/Governikus/AusweisApp2/releases";
    homepage = "https://www.ausweisapp.bund.de/ausweisapp2/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.linux;
  };
}
