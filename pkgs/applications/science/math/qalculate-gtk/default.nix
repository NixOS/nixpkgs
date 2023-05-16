<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, curl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "4.8.0";
=======
{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "4.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-GYy3Ot2vjXpCp89Rib3Ua0XeVGOOTejKcaqNZvPmxm0=";
=======
    sha256 = "sha256-eBclDq9Uiu5rA74tlBkOiP3fRwAZn84F3LPA2cKkuw8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook ];
<<<<<<< HEAD
  buildInputs = [ libqalculate gtk3 curl ];
=======
  buildInputs = [ libqalculate gtk3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner doronbehar alyaeanyx ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
