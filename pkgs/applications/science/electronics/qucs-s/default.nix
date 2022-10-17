{ stdenv, lib, fetchFromGitHub, flex, bison, qt4, libX11, cmake, gperf, adms,
ngspice, wrapGAppsHook,
kernels ? [ ngspice ] }:

stdenv.mkDerivation rec {
  pname = "qucs-s";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucs_s";
    rev = version;
    sha256 = "0rrq2ddridc09m6fixdmbngn42xmv8cmdf6r8zzn2s98fqib5qd6";
  };

  nativeBuildInputs = [ wrapGAppsHook cmake ];
  buildInputs = [ flex bison qt4 libX11 gperf adms ] ++ kernels;

  preConfigure = ''
    # Make custom kernels avaible from qucs-s
    gappsWrapperArgs+=(--prefix PATH ":" ${lib.escapeShellArg (lib.makeBinPath kernels)})
  '';

  QTDIR=qt4;

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
