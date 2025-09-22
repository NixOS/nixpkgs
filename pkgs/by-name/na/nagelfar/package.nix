{
  lib,
  fetchurl,
  tcl,
  tclPackages,
  tk,
}:

tcl.mkTclDerivation rec {
  pname = "nagelfar";
  version = "1.3.5";

  src = fetchurl {
    url = "https://sourceforge.net/projects/nagelfar/files/Rel_${
      lib.replaceString "." "" version
    }/nagelfar${lib.replaceString "." "" version}.tar.gz";
    hash = "sha256-O6+SD7NLc+MgZxGDZdB02FkpjivON0itlFhiS+zoWyM=";
  };

  buildInputs = [
    tcl
    tclPackages.tcllib
    tk
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 nagelfar.tcl $out/bin/nagelfar

    runHook postInstall
  '';

  meta = {
    homepage = "https://nagelfar.sourceforge.net/";
    description = "Static syntax checker (linter) for Tcl";
    longDescription = ''
      Provides static syntax checking, code coverage instrumentation,
      and is very extendable through its syntax database and plugins.
    '';
    mainProgram = "nagelfar";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nat-418 ];
  };
}
