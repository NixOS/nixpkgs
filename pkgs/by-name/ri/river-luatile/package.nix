{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  luajit,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-luatile";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${version}";
    hash = "sha256-8/qHoNFoGH1nSdTwBkaQk+yyvJtrXADTA39gUAMeSv8=";
  };

  cargoHash = "sha256-KQO6JN+ed+gxTTBGoJYhVUrpHJkuXf1dHrUzcF5FNaY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    luajit
  ];

<<<<<<< HEAD
  meta = {
    description = "Write your own river layout generator in lua";
    homepage = "https://github.com/MaxVerevkin/river-luatile";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pinpox ];
=======
  meta = with lib; {
    description = "Write your own river layout generator in lua";
    homepage = "https://github.com/MaxVerevkin/river-luatile";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pinpox ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "river-luatile";
  };
}
