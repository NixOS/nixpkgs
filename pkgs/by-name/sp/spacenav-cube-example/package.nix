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

<<<<<<< HEAD
  meta = {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Example application to test the spacenavd driver";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sohalt ];
=======
  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Example application to test the spacenavd driver";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "spacenav-cube-example";
  };
}
