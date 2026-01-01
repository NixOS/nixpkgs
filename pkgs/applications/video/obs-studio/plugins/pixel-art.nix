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

<<<<<<< HEAD
  meta = {
    description = "OBS Plugin that can be used to create retro-inspired pixel art visuals";
    homepage = "https://github.com/dspstanky/pixel-art";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "OBS Plugin that can be used to create retro-inspired pixel art visuals";
    homepage = "https://github.com/dspstanky/pixel-art";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (obs-studio.meta) platforms;
  };
}
