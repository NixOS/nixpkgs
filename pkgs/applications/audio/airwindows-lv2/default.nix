<<<<<<< HEAD
{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "22.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u62wLRrJ45ap981Q8JmMnanc8AWQb1MJHK32PEr10I4=";
=======
{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "18.0";
  src = fetchFromGitHub {
    owner = "hannesbraun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-06mfTvt0BXHUGZG2rnEbuOPIP+jD76mQZTo+m4b4lo4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ lv2 ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
<<<<<<< HEAD
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
=======
    homepage = "https://github.com/hannesbraun/airwindows-lv2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
