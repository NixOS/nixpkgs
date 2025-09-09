{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "arduino-mk";

  src = fetchFromGitHub {
    owner = "sudar";
    repo = "Arduino-Makefile";
    rev = version;
    hash = "sha256-XdBGoGB8FzAYv0+H6NTviAY/3MbEDxvKfWEI0U6ilzo=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    installShellFiles
  ];
  propagatedBuildInputs = with python3Packages; [ pyserial ];
  installPhase = ''
    mkdir $out
    cp -rT $src $out
    installManPage *.1
  '';
  postFixupPhase = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Makefile for Arduino sketches";
    homepage = "https://github.com/sudar/Arduino-Makefile";
    license = licenses.lgpl21;
    maintainers = [ maintainers.eyjhb ];
    platforms = platforms.unix;
  };
}
