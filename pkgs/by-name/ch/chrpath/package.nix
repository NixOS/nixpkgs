{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "chrpath";
  version = "0.18";

  src = fetchurl {
    url = "https://codeberg.org/pere/chrpath/archive/release-${version}.tar.gz";
    hash = "sha256-8JxJ8GGGYMoR/G2VgN3ekExyJNTG0Pby0fm83JECyao=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line tool to adjust the RPATH or RUNPATH of ELF binaries";
    mainProgram = "chrpath";
    longDescription = ''
      chrpath changes, lists or removes the rpath or runpath setting in a
      binary. The rpath, or runpath if it is present, is where the runtime
      linker should look for the libraries needed for a program.
    '';
    homepage = "https://codeberg.org/pere/chrpath";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
=======
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
