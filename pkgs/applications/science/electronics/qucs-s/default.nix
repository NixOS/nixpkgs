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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
    sha256 = "sha256-cQ9UNCTwRW61dOQYJX0mPNtCTk0qXKx8VQ6BIXl6Fa8=";
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
    maintainers = with maintainers; [ mazurel ];
    platforms = with platforms; linux;
  };
}
