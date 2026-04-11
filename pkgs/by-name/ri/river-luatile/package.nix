{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  luajit,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "river-luatile";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8/qHoNFoGH1nSdTwBkaQk+yyvJtrXADTA39gUAMeSv8=";
  };

  cargoHash = "sha256-KQO6JN+ed+gxTTBGoJYhVUrpHJkuXf1dHrUzcF5FNaY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    luajit
  ];

  meta = {
    description = "Write your own river layout generator in lua";
    homepage = "https://github.com/MaxVerevkin/river-luatile";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "river-luatile";
  };
})
