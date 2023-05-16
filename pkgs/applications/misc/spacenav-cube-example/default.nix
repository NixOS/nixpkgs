{ stdenv, lib, libspnav, libX11, mesa_glu }:

stdenv.mkDerivation {
  pname = "spacenav-cube-example";
<<<<<<< HEAD
  inherit (libspnav) version src;

  sourceRoot = "${libspnav.src.name}/examples/cube";
=======
  version = libspnav.version;

  src = libspnav.src;

  sourceRoot = "source/examples/cube";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libX11 mesa_glu libspnav ];

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
  };
}
