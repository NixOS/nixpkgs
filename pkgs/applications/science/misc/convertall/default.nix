{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  wrapQtAppsHook,
}:

let
  inherit (python3.pkgs) wrapPython pyqt5;
in
stdenv.mkDerivation rec {
  pname = "convertall";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "doug-101";
    repo = "ConvertAll";
    rev = "v${version}";
    sha256 = "02xxasgbjbivsbhyfpn3cpv52lscdx5kc95s6ns1dvnmdg0fpng0";
  };

  nativeBuildInputs = [
    python3
    wrapPython
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [ pyqt5 ];

  installPhase = ''
    python3 install.py -p $out -x
  '';

  postFixup = ''
    buildPythonPath $out
    patchPythonScript $out/share/convertall/convertall.py
    makeQtWrapper $out/share/convertall/convertall.py $out/bin/convertall
  '';

  meta = with lib; {
    homepage = "https://convertall.bellz.org/";
    description = "Graphical unit converter";
    mainProgram = "convertall";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = pyqt5.meta.platforms;
  };
}
