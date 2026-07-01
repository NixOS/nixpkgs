{
  stdenv,
  lib,
  libspnav,
  libx11,
  mesa_glu,
}:

stdenv.mkDerivation {
  pname = "spacenav-cube-example";
  inherit (libspnav) version src;

  sourceRoot = "${libspnav.src.name}/examples/cube";

  buildInputs = [
    libx11
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

  meta = {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Example application to test the spacenavd driver";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sohalt ];
    mainProgram = "spacenav-cube-example";
  };
}
