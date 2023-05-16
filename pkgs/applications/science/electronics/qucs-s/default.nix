{ stdenv
, lib
, fetchFromGitHub
, flex
, bison
, qtbase
, qttools
, qtsvg
, qtwayland
, wrapQtAppsHook
, libX11
, cmake
, gperf
, adms
, ngspice
, kernels ? [ ngspice ]
}:

stdenv.mkDerivation rec {
  pname = "qucs-s";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-9/1sgxFqn9d9zlwrzjQosFO3m+2lC83qVcCtzfqY5XY=";
=======
    sha256 = "sha256-2YyVeeUnLBS1Si9gwEsQLZVG98715dz/v+WCYjB3QlI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ flex bison wrapQtAppsHook cmake ];
  buildInputs = [ qtbase qttools qtsvg qtwayland libX11 gperf adms ] ++ kernels;

  # Make custom kernels avaible from qucs-s
  qtWrapperArgs = [ "--prefix" "PATH" ":" (lib.makeBinPath kernels) ];

  QTDIR = qtbase.dev;

  doInstallCheck = true;
  installCheck = ''
    $out/bin/qucs-s --version
  '';

  meta = with lib; {
    description = "Spin-off of Qucs that allows custom simulation kernels";
    longDescription = ''
      Spin-off of Qucs that allows custom simulation kernels.
      Default version is installed with ngspice.
    '';
    homepage = "https://ra3xdh.github.io/";
    license = licenses.gpl2Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ mazurel kashw2 ];
=======
    maintainers = with maintainers; [ mazurel ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = with platforms; linux;
  };
}
