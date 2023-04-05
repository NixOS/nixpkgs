{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, luajit
}:

rustPlatform.buildRustPackage rec {
  pname = "river-luatile";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${version}";
    hash = "sha256-flh1zUBranb7w1fQuinHbVRGlVxfl2aKxSwShHFG6tI=";
  };

  cargoHash = "sha256-9YQxa6folwCJNoEa75InRbK1X7cD4F5QGzeGlfsr/5s=";

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
