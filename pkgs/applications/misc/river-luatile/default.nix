{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, luajit
}:

rustPlatform.buildRustPackage rec {
  pname = "river-luatile";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${version}";
    hash = "sha256-ZBytoj4L72TjxJ7vFivjcSO69AcdwKNbXh4rA/bn5iU=";
  };

  cargoHash = "sha256-GcMSglLKuUD3nVj0/8Nbrk4qs5gl5PlCj7r1MYq/vQg=";

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
