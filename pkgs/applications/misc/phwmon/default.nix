{ lib, stdenv, fetchFromGitLab, python2Packages }:

stdenv.mkDerivation {
  pname = "phwmon";
  version = "2017-04-10";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "phwmon";
    rev = "b162e53dccc4adf8f11f49408d05fd85d9c6c909";
    sha256 = "1hqmsq66y8bqkpvszw84jyk8haxq3cjnz105hlkmp7786vfmkisq";
  };

  nativeBuildInputs = [ python2Packages.wrapPython ];

  buildInputs = [ python2Packages.pygtk python2Packages.psutil ];

  pythonPath = [ python2Packages.pygtk python2Packages.psutil ];

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
    homepage = "https://gitlab.com/o9000/phwmon";
    description = "Hardware monitor (CPU, memory, network and disk I/O) for the system tray";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
