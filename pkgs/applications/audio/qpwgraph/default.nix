{ lib, mkDerivation, fetchFromGitLab
, cmake, pkg-config
, alsa-lib, pipewire
}:

mkDerivation rec {
  pname = "qpwgraph";
<<<<<<< HEAD
  version = "0.5.2";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "rncbc";
    repo = "qpwgraph";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-qcd19YI2RDoh+vjeelxNajWsUwVokLu0kh35a4oezKA=";
=======
    sha256 = "sha256-bOg+7bNEhnemhb+Xi3x77ZEjqKFjUXSCFgvcLXrxz/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ alsa-lib pipewire ];

  meta = with lib; {
    description = "Qt graph manager for PipeWire, similar to QjackCtl.";
    longDescription = ''
      qpwgraph is a graph manager dedicated for PipeWire,
      using the Qt C++ framework, based and pretty much like
      the same of QjackCtl.
    '';
    homepage = "https://gitlab.freedesktop.org/rncbc/qpwgraph";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ kanashimia exi Scrumplex ];
=======
    maintainers = with maintainers; [ kanashimia exi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
