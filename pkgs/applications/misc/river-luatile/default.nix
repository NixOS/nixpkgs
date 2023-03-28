{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, luajit
}:

rustPlatform.buildRustPackage rec {
  pname = "river-luatile";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${version}";
    hash = "sha256-eZgoFbat7X/jh5udlNyIuTheBUCHpaVRbsojYLATO18=";
  };

  cargoHash = "sha256-Vqyt5bL1lVhy/Wxd+zF7Wugvb7dW1N9Kq2TTFSaodnE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    luajit
  ];

  meta = with lib; {
    description = "Write your own river layout generator in lua";
    homepage = "https://github.com/MaxVerevkin/river-luatile";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pinpox ];
  };
}
