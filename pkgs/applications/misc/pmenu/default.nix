{ stdenv, fetchFromGitLab, python2Packages, gnome3 }:

stdenv.mkDerivation rec {
  name = "pmenu-${version}";
  version = "2017-04-10";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "pmenu";
    rev = "87fec9ddf594f1046d03348de2bafcfa6e94cfd1";
    sha256 = "0ynhml46bi5k52v7fw2pjpcac9dswkmlvh6gynvnyqjp4p153fl4";
  };

  nativeBuildInputs = [ python2Packages.wrapPython ];

  buildInputs = [ python2Packages.pygtk gnome3.gnome-menus ];

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
