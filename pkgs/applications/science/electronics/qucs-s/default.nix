{ stdenv
, lib
, fetchFromGitHub
, flex
, bison
, qtbase
, qtcharts
, qttools
, qtsvg
, qtwayland
, wrapQtAppsHook
, libX11
, cmake
, gperf
, adms
, ngspice
, qucsator-rf
, kernels ? [ ngspice qucsator-rf ]
}:

stdenv.mkDerivation rec {
  pname = "qucs-s";
  version = "24.4.1";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
    hash = "sha256-ll5P8cqJBzoieExElggn5tRbDcmH7L3yvcbtAQ0BBww=";
  };

  nativeBuildInputs = [ flex bison wrapQtAppsHook cmake ];
  buildInputs = [ qtbase qttools qtcharts qtsvg qtwayland libX11 gperf adms ] ++ kernels;

  cmakeFlags = [
    "-DWITH_QT6=ON"
  ];

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
    mainProgram = "qucs-s";
    maintainers = with maintainers; [ mazurel kashw2 thomaslepoix ];
    platforms = with platforms; linux;
  };
}
