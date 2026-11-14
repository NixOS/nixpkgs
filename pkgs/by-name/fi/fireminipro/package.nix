{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  minipro,
  libxkbcommon,
  mesa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fireminipro";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "Jartza";
    repo = "fireminipro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+flVdPInMBnQgQyqXkbvrMcth0/4yII36xdjSnfe+wE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    minipro
    libxkbcommon
    mesa
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    if [ "$system" = "x86_64-darwin" ] || [ "$system" = "aarch64-darwin" ]; then
      install -D fireminipro.app/Contents/MacOS/fireminipro --target-directory=$out/bin
    else
      install -D fireminipro --target-directory=$out/bin
    fi

    runHook postInstall
  '';

  patches = [ ./darwin-finder.patch ];


  meta = {
    description = "Modern, cross-platform graphical front-end for the Minipro programmer software";
    homepage = "https://github.com/Jartza/fireminipro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nulleric ];
    mainProgram = "fireminipro";
  };
})
