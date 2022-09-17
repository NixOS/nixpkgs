{ lib, mkDerivation, fetchFromGitHub, cmake, doxygen, makeWrapper
, msgpack, neovim, python3Packages, qtbase, qtsvg }:

mkDerivation rec {
  pname = "neovim-qt-unwrapped";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner  = "equalsraf";
    repo   = "neovim-qt";
    rev    = "v${version}";
    sha256 = "sha256-UJXaHENqau5EEe5c94pJuNxZU5rutJs642w9Cof8Sa4=";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_MSGPACK=1"
    "-DENABLE_TESTS=0"  # tests fail because xcb platform plugin is not found
  ];

  buildInputs = [
    neovim.unwrapped # only used to generate help tags at build time
    qtbase
    qtsvg
  ] ++ (with python3Packages; [
    jinja2 python msgpack
  ]);

  nativeBuildInputs = [ cmake doxygen ];

  preCheck = ''
    # The GUI tests require a running X server, disable them
    sed -i ../test/CMakeLists.txt -e '/^add_xtest_gui/d'
  '';

  doCheck = true;

  meta = with lib; {
    description = "Neovim client library and GUI, in Qt5";
    homepage = "https://github.com/equalsraf/neovim-qt";
    license     = licenses.isc;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (neovim.meta) platforms;
  };
}
