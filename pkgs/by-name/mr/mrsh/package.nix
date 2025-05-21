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
    sha256 = "0vvdwzw3fq74lwgmy6xxkk01sd68fzhsw84c750lm1dma22xhjci";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ readline ];

  doCheck = true;

  meta = with lib; {
    description = "Minimal POSIX shell";
    mainProgram = "mrsh";
    homepage = "https://mrsh.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };

  passthru = {
    shellPath = "/bin/mrsh";
  };
}
