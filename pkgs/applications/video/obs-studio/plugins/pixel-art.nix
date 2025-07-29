{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "pixel-art";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "dspstanky";
    repo = "pixel-art";
    rev = version;
    sha256 = "sha256-7o63e7nK/JsK2SQg0AzUYcc4ZsPx0lt8gtAQm8Zy+9w=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = with lib; {
    description = "An OBS Plugin that can be used to create retro-inspired pixel art visuals";
    homepage = "https://github.com/dspstanky/pixel-art";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
