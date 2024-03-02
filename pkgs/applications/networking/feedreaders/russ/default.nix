{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, xorg
}:

rustPlatform.buildRustPackage {
  pname = "russ";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ckampfe";
    repo = "russ";
    rev = "1482bb1df13738fdd4ea1badf2146a9ed8e6656e";
    hash = "sha256-MvTMo2q/cQ/LQNdUV8SmHgGlA42kLl0i9mdcoAFV/I4=";
  };

  cargoHash = "sha256-ObWrwXMGXkLqqM7VXhOXArshk2lVkbOTXhrQImDQp1s=";

  # tests are network based :(
  doCheck = false;

  meta = with lib; {
    description = "A TUI RSS reader with vim-like controls and a local-first, offline-first focus";
    homepage = "https://github.com/ckampfe/russ";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ blusk ];
    changelog = "https://github.com/ckampfe/russ/blob/master/CHANGELOG.md";
    broken = stdenv.isDarwin;
  };
}
