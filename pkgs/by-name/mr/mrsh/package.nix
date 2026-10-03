{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  readline,
}:

stdenv.mkDerivation {
  pname = "mrsh-unstable";
  version = "2021-01-10";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "9f9884083831ea1f94bdda5151c5df3888932849";
    hash = "sha256-kUnYhVC1hUpBOYwgruF3yDQdwJy9G18fp+RgN/jnbW8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ readline ];

  doCheck = true;

  meta = {
    description = "Minimal POSIX shell";
    mainProgram = "mrsh";
    homepage = "https://github.com/emersion/mrsh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
  };

  passthru = {
    shellPath = "/bin/mrsh";
  };
}
