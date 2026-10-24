{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  glibcLocales,
}:

stdenv.mkDerivation {
  pname = "libfort";
  version = "0.5.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "seleznevae";
    repo = "libfort";
    tag = "v0.5.2";
    hash = "sha256-BtezW2cWiSrm8luZHd+fFZpXpjGp5KXxgqFpljMys9A=";
  };

  nativeBuildInputs = [
    cmake
    glibcLocales
  ];

  doCheck = true;
  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    ctest --output-on-failure
  '';

  meta = with lib; {
    description = "C/C++ library to create formatted ASCII tables for console applications";
    homepage = "https://github.com/seleznevae/libfort";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ arntanguy ];
  };
}
