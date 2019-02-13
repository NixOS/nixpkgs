{ stdenv, fetchFromGitLab, python2Packages, gnome-menus }:

stdenv.mkDerivation rec {
  name = "pmenu-${version}";
  version = "2018-01-01";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "pmenu";
    rev = "f98a5bdf20deb0b7f0543e5ce6a8f5574f695e07";
    sha256 = "131nqafbmbfpgsgss27pz4cyb9fb29m5h1ai1fyvcn286rr9dnp2";
  };

  nativeBuildInputs = [ python2Packages.wrapPython ];

  buildInputs = [ python2Packages.pygtk gnome-menus ];

  pythonPath = [ python2Packages.pygtk ];
    
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ./install.sh $out
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = https://gitlab.com/o9000/pmenu;
    description = "Start menu for Linux/BSD";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
