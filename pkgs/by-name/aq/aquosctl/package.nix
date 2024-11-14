{ lib
, stdenv
, fetchFromGitHub
}:

let
  pname = "aquosctl";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2014-04-06";

  src = fetchFromGitHub {
    owner = "jdwhite";
    repo = pname;
    rev = "b5e48d9ef848188b97dfb24bfcc99d5196cab5f6";
    hash = "sha256-FA3LR58KMG5RzSxxnOkVw1+inM/gMGPtw5+JQwSHBYs=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm0755 aquosctl $out/bin/aquosctl
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sharp Aquos television RS-232 control application";
    homepage = "https://github.com/jdwhite/aquosctl";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
    mainProgram = "aquosctl";
  };
}

