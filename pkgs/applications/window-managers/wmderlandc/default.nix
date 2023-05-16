{ lib, stdenv, fetchFromGitHub, cmake, libX11, xorgproto }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "wmderlandc";
  version = "unstable-2020-07-17";

  src = fetchFromGitHub {
    owner = "aesophor";
    repo = "wmderland";
    rev = "a40a3505dd735b401d937203ab6d8d1978307d72";
    sha256 = "0npmlnybblp82mfpinjbz7dhwqgpdqc1s63wc1zs8mlcs19pdh98";
  };

<<<<<<< HEAD
  sourceRoot = "${finalAttrs.src.name}/ipc-client";
=======
  sourceRoot = "source/ipc-client";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libX11
    xorgproto
  ];

  meta = with lib; {
    description = "A tiny program to interact with wmderland";
    homepage = "https://github.com/aesophor/wmderland/tree/master/ipc-client";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ takagiy ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
