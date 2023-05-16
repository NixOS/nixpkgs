{ lib, stdenv, fetchFromGitHub, libevent, glew, glfw }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pixelnuke";
  version = "unstable-2019-05-19";

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "pixelflut";
    rev = "3458157a242ba1789de7ce308480f4e1cbacc916";
    sha256 = "03dp0p00chy00njl4w02ahxqiwqpjsrvwg8j4yi4dgckkc3gbh40";
  };

<<<<<<< HEAD
  sourceRoot = "${finalAttrs.src.name}/pixelnuke";
=======
  sourceRoot = "source/pixelnuke";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libevent glew glfw ];

  installPhase = ''
    install -Dm755 ./pixelnuke $out/bin/pixelnuke
  '';

  meta = with lib; {
    description = "Multiplayer canvas (C implementation)";
    homepage = "https://cccgoe.de/wiki/Pixelflut";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mrVanDalo ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
