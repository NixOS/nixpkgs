{
  stdenv,
  lib,
  libspnav,
  libX11,
  mesa_glu,
}:

stdenv.mkDerivation {
  pname = "spacenav-cube-example";
  inherit (libspnav) version src;

  sourceRoot = "${libspnav.src.name}/examples/cube";

  buildInputs = [
    libX11
    mesa_glu
    libspnav
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp cube $out/bin/spacenav-cube-example
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "An example application to test the spacenavd driver";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
    mainProgram = "spacenav-cube-example";
  };
}
