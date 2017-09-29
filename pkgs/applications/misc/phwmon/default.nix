{ stdenv, fetchFromGitLab, pythonPackages }:

stdenv.mkDerivation rec {
  name = "phwmon-${version}";
  version = "2017-04-10";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "phwmon";
    rev = "b162e53dccc4adf8f11f49408d05fd85d9c6c909";
    sha256 = "1hqmsq66y8bqkpvszw84jyk8haxq3cjnz105hlkmp7786vfmkisq";
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
