{
  lib,
  stdenv,
  fetchFromGitHub,
  bobcat,
  icmake,
  yodl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flexc++";
  version = "2.05.00";

  src = fetchFromGitHub {
    hash = "sha256-n3/FeRJ3jD+++xSzoeQPWA3xeWeIOJ7JqBtrp2VqRWg=";
    rev = finalAttrs.version;
    repo = "flexcpp";
    owner = "fbb-git";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */flexc++)
  '';

  buildInputs = [ bobcat ];
  nativeBuildInputs = [
    icmake
    yodl
  ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build man
    ./build manual
    ./build program
  '';

  installPhase = ''
    ./build install x
  '';

  meta = {
    description = "C++ tool for generating lexical scanners";
    mainProgram = "flexc++";
    longDescription = ''
      Flexc++ was designed after `flex'. Flexc++ offers a cleaner class design
      and requires simpler specification files than offered by flex's C++
      option.
    '';
    homepage = "https://fbb-git.github.io/flexcpp/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
