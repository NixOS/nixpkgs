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
    install -D fireminipro --target-directory=$out/bin
    runHook postInstall
  '';

  meta = {
    description = "Modern, cross-platform graphical front-end for the Minipro programmer software";
    homepage = "https://github.com/Jartza/fireminipro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nulleric ];
    mainProgram = "fireminipro";
  };
})
