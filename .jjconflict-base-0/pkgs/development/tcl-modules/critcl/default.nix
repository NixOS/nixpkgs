{ lib
, fetchFromGitHub
, mkTclDerivation
, tcl
, tcllib
}:

mkTclDerivation rec {
  pname = "critcl";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "andreas-kupries";
    repo = "critcl";
    rev = version;
    hash = "sha256-LBTAuwTrvwj42vo/TXVSUK8euxHgvSLai23e1jmhMso=";
  };

  buildInputs = [
    tcl
    tcllib
  ];

  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    runHook preInstall
    HOME="$(mktemp -d)" tclsh ./build.tcl test
    runHook postInstall
  '';

  installPhase = ''
    runHook preInstall
    tclsh ./build.tcl install --prefix $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Easily embed C code in Tcl";
    homepage = "https://andreas-kupries.github.io/critcl/";
    license = licenses.tcltk;
    mainProgram = "critcl";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
