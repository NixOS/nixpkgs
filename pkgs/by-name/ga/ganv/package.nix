{
  lib,
  stdenv,
  fetchFromGitLab,
  graphviz,
  gtk2,
  gtkmm2,
  meson,
  ninja,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "ganv";
  version = "1.8.2-unstable-2024-07-04";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "ganv";
    rev = "4d2e04dbcabd0b5d715ea7eeeb909f4088055763";
    hash = "sha256-DzODtYI8uwP65ck8Q90QEnjQbvPobepeQVgNZZjF+jk=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
  ];

  buildInputs = [
    gtk2
    gtkmm2
    graphviz
  ];

  strictDeps = true;

  # libintl detection does not work even if provided
  mesonAutoFeatures = "disabled";

  meta = {
    description = "Interactive Gtk canvas widget for graph-based interfaces";
    mainProgram = "ganv_bench";
    homepage = "http://drobilla.net";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
  };
}
