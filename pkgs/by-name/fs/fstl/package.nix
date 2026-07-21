{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fstl";
  version = "0.11.1";

  postPatch = ''
    patchShebangs --build xdg/xdg_install.sh
    substituteInPlace xdg/fstlapp-fstl.desktop \
      --replace-fail 'Exec=fstl' 'Exec=${placeholder "out"}/bin/fstl'
  '';

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    xdg-utils
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    mv fstl.app $out/Applications

    runHook postInstall
  '';

  postInstall = ''
    env --chdir ../xdg XDG_DATA_HOME=$out/share ./xdg_install.sh fstl
  '';

  src = fetchFromGitHub {
    owner = "fstl-app";
    repo = "fstl";
    rev = "v" + finalAttrs.version;
    hash = "sha256-puDYXANiyTluSlmnT+gnNPA5eCcw0Ny6md6Ock6pqLc=";
  };

  meta = {
    description = "Fastest STL file viewer";
    mainProgram = "fstl";
    homepage = "https://github.com/fstl-app/fstl";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ tweber ];
  };
})
