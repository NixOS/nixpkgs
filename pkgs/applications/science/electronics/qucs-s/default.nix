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
  version = "25.1.0";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
    hash = "sha256-yu9sBaFmEYWjDOEAGpA4pKTAYUjPGf/Zv7VnRDCIAK4=";
  };

  postPatch = ''
    # Workaround a CMake bug (we don't generally do distributable bundles in nixpkgs anyway):
    #   warning: cannot resolve item '/usr/lib/libSystem.B.dylib'
    #
    #   possible problems:
    #       need more directories?
    #           need to use InstallRequiredSystemLibraries?
    #               run in install tree instead of build tree?
    for filename in \
      qucs/CMakeLists.txt \
      qucs-transcalc/CMakeLists.txt \
      qucs-attenuator/CMakeLists.txt \
      qucs-s-spar-viewer/CMakeLists.txt \
      ; do
      substituteInPlace "$filename" \
        --replace-fail 'fixup_bundle(' 'message(\"nixpkgs will not fixup_bundle: \" '
    done
  '';

  nativeBuildInputs = [ flex bison wrapQtAppsHook cmake ];
  buildInputs = [ qtbase qttools qtcharts qtsvg gperf adms ]
    ++ lib.optionals stdenv.isLinux [ qtwayland libX11 ]
    ++ kernels;

  cmakeFlags = [
    "-DWITH_QT6=ON"
  ];

  # Make custom kernels available from qucs-s
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
    platforms = with platforms; unix;
  };
}
