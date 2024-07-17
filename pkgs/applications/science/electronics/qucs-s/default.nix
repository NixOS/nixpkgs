{
  stdenv,
  lib,
  fetchFromGitHub,
  flex,
  bison,
  qtbase,
  qttools,
  qtsvg,
  qtwayland,
  wrapQtAppsHook,
  libX11,
  cmake,
  gperf,
  adms,
  ngspice,
  kernels ? [ ngspice ],
}:

stdenv.mkDerivation rec {
  pname = "qucs-s";
  version = "24.1.0";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
    sha256 = "sha256-ei9CPlJg+Kfjh7vu5VnT6DNLmmnA8wZ2A1jXnm//Fgo=";
  };

  nativeBuildInputs = [
    flex
    bison
    wrapQtAppsHook
    cmake
  ];
  buildInputs = [
    qtbase
    qttools
    qtsvg
    qtwayland
    libX11
    gperf
    adms
  ] ++ kernels;

  # Make custom kernels avaible from qucs-s
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath kernels)
  ];

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
    maintainers = with maintainers; [
      mazurel
      kashw2
    ];
    platforms = with platforms; linux;
  };
}
