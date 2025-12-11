{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "notes";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ceZ37torgnxZJybacjnNG+kNAU/I2Ki7ZZ7Tzn4pIas=";
    fetchSubmodules = true;
  };

  patches = [
    # Based on https://github.com/nuttyartist/notes/pull/758 which doesn't apply cleanly
    ./qt610-fix.patch
  ];

  cmakeFlags = [ "-DUPDATE_CHECKER=OFF" ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/Notes.app $out/Applications
  '';

  meta = {
    description = "Fast and beautiful note-taking app";
    homepage = "https://github.com/nuttyartist/notes";
    mainProgram = "notes";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
