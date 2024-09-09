{ lib, clangStdenv, fetchzip }:

clangStdenv.mkDerivation rec {
  pname = "zchaff";
  version = "2007.3.12";

  src = fetchzip {
    url = "https://www.princeton.edu/~chaff/zchaff/zchaff.64bit.${version}.zip";
    sha256 = "sha256-88fAtJb7o+Qv2GohTdmquxMEq4oCbiKbqLFmS7zs1Ak=";
  };

  patches = [ ./sat_solver.patch ];
  postPatch = ''
    substituteInPlace zchaff_solver.cpp --replace "// #define VERIFY_ON" "#define VERIFY_ON"
  '';

  makeFlags = [ "CC=${clangStdenv.cc.targetPrefix}c++" ];
  installPhase= ''
    runHook preInstall
    install -Dm755 -t $out/bin zchaff
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.princeton.edu/~chaff/zchaf";
    description = "Accelerated SAT Solver from Princeton";
    mainProgram = "zchaff";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
