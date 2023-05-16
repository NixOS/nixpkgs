{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, gtk3, vte, lua5_3, pcre2 }:

stdenv.mkDerivation rec {
  pname = "tym";
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "${pname}";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-aXV3TNjHxg/9Lb2o+ci5/cCAPbkWhxqOka3wv21ajSA=";
=======
    rev = "${version}";
    sha256 = "sha256-5pXNOuMT2/G+m6XoTrwNTCGNfISLLy0wQpVPhQJzs4s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    gtk3
    vte
    lua5_3
    pcre2
  ];

  meta = with lib; {
    description = "Lua-configurable terminal emulator";
    homepage = "https://github.com/endaaman/tym";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ wesleyjrz kashw2 ];
=======
    maintainers = [ maintainers.wesleyjrz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
