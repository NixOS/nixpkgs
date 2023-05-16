<<<<<<< HEAD
{ lib, stdenv, fetchurl, fftwSinglePrec, lv2, pkg-config, waf, python3 }:
=======
{ lib, stdenv, fetchurl, fftwSinglePrec, lv2, pkg-config, wafHook, python3 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "mda-lv2";
  version = "1.2.6";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zWYRcCSuBJzzrKg/npBKcCdyJOI6lp9yqcXQEKSYV9s=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config waf.hook python3 ];
  buildInputs = [ fftwSinglePrec lv2 ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/mda-lv2.html";
=======
  nativeBuildInputs = [ pkg-config wafHook python3 ];
  buildInputs = [ fftwSinglePrec lv2 ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/mda-lv2/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "An LV2 port of the MDA plugins by Paul Kellett";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
