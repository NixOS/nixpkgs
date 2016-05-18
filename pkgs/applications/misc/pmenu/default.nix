{ stdenv, fetchFromGitLab, pythonPackages, gnome }:

stdenv.mkDerivation rec {
  name = "pmenu-${version}";
  version = "2016-05-13";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "pmenu";
    rev = "90b722de345cff56f8ec0908a0e8a7d733c0c671";
    sha256 = "15bkvadr7ab44mc8gkdqs3w14cm498mwf72w5rjm2rdh55357jjh";
  };

  nativeBuildInputs = [ pythonPackages.wrapPython ];

  buildInputs = [ pythonPackages.pygtk gnome.gnome_menus ];

  pythonPath = [ pythonPackages.pygtk ];
  
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
    homepage = https://gitlab.com/o9000/pmenu;
    description = "Start menu for Linux/BSD";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
