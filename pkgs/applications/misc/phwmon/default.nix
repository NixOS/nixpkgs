{ stdenv, fetchFromGitLab, pythonPackages }:

stdenv.mkDerivation rec {
  name = "phwmon-${version}";
  version = "2016-03-13";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "phwmon";
    rev = "90247ceaff915ad1040352c5cc9195e4153472d4";
    sha256 = "1gkjfmd8rai7bl1j7jz9drmzlw72n7mczl0akv39ya4l6k8plzvv";
  };

  nativeBuildInputs = [ pythonPackages.wrapPython ];

  buildInputs = [ pythonPackages.pygtk pythonPackages.psutil ];

  pythonPath = [ pythonPackages.pygtk pythonPackages.psutil ];
  
  patchPhase = ''
    substituteInPlace install.sh --replace "/usr/local" "$out"
  '';
    
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ./install.sh
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = https://gitlab.com/o9000/phwmon;
    description = "Hardware monitor (CPU, memory, network and disk I/O) for the system tray";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
