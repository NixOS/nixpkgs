{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dsda-launcher";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Pedro-Beirao";
    repo = "dsda-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMgxhb+9GdLK00nl/df9QiYYewr+YEjdX2KjQWvu1mk=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "./src/build"
    cd "./src/build"
    qmake6 ..
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./dsda-launcher $out/bin
    install -Dm444 ../icons/dsda-Launcher.desktop $out/share/applications/dsda-Launcher.desktop
    install -Dm444 ../icons/dsda-launcher.png $out/share/pixmaps/dsda-launcher.png
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Pedro-Beirao/dsda-launcher";
    description = "Launcher GUI for the dsda-doom source port";
    mainProgram = "dsda-launcher";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
})
