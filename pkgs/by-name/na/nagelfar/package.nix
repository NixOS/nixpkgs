{
  lib,
  fetchzip,
  tcl,
  tclPackages,
  tk,
}:

tcl.mkTclDerivation {
  pname = "nagelfar";
  version = "1.3.3";

  src = fetchzip {
    url = "https://sourceforge.net/projects/nagelfar/files/Rel_133/nagelfar133.tar.gz";
    sha256 = "sha256-bdH53LSOKMwq53obVQitl7bpaSpwvMce8oJgg/GKrg0=";
  };

  buildInputs = [
    tcl
    tclPackages.tcllib
    tk
  ];

  installPhase = ''
    install -Dm 755 $src/nagelfar.tcl $out/bin/nagelfar
  '';

  meta = with lib; {
    homepage = "https://nagelfar.sourceforge.net/";
    description = "Static syntax checker (linter) for Tcl";
    longDescription = ''
      Provides static syntax checking, code coverage instrumentation,
      and is very extendable through its syntax database and plugins.
    '';
    mainProgram = "nagelfar";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.nat-418 ];
  };
}
