{ lib, fetchurl, stdenv, libiconv, ncurses, lua }:

stdenv.mkDerivation rec {
  pname = "dit";
<<<<<<< HEAD
  version = "0.9";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-p1uD0Q2kqB40fbAEk7/fdOVg9T7SW+2aACSn7hDAD+E=";
=======
  version = "0.7";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "0cmbyzqfz2qa83cg8lpjifn34wmx34c5innw485zh4vk3c0k8wlj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses lua ]
    ++ lib.optional stdenv.isDarwin libiconv;

  # fix paths
  prePatch = ''
    patchShebangs tools/GenHeaders
    substituteInPlace Prototypes.h --replace 'tail' "$(type -P tail)"
  '';

  meta = with lib; {
    description = "A console text editor for Unix that you already know how to use";
    homepage = "https://hisham.hm/dit/";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ davidak ];
  };
}
