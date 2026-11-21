{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  ftxui,
  xxd,
}:
stdenv.mkDerivation {
  pname = "bonsai-tui";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "orrnithogalum";
    repo = "bonsai";
    rev = "512d124a81c81420424ea34f72d076499f3b840e";
    hash = "sha256-C9G5phL5nLSFL4eYcuJcM3gv2fUAzgx8IfRy60UAboM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ftxui
    xxd
  ];

  patches = [
    # Remove FetchContent from CMake
    ./no-fetchcontent.patch
    # Add install phase to CMake
    ./add-install-phase.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Terminal user interface (TUI) remake of the GNOME Baobab disk usage analyzer";
    homepage = "https://github.com/orrnithogalum/bonsai/tree/main";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      dawoox
    ];
    mainProgram = "bonsai";
    platforms = lib.platforms.linux;
  };
}
