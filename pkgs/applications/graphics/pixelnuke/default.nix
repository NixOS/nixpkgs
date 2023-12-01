{ lib, stdenv, fetchFromGitHub, libevent, glew, glfw }:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixelnuke";
  version = "unstable-2019-05-19";

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "pixelflut";
    rev = "3458157a242ba1789de7ce308480f4e1cbacc916";
    sha256 = "03dp0p00chy00njl4w02ahxqiwqpjsrvwg8j4yi4dgckkc3gbh40";
  };

  sourceRoot = "${finalAttrs.src.name}/pixelnuke";

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
})
