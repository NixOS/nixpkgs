{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  gnumake,
  pkg-config,
  libusb1,
  hidapi,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "icesprog";
  version = "1.1b";

  src = fetchFromGitHub {
    owner = "wuxx";
    repo = "icesugar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LGmT+GEZvo0oxmr2kMfSztutnguPpNt2QJfVyBJo82w=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools/src";
  strictDeps = true;

  nativeBuildInputs = [
    gnumake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libusb1
    hidapi
  ];

  installPhase = ''
    runHook preInstall

    installBin icesprog

    runHook postInstall
  '';

  meta = {
    description = "iCESugar FPGA flash utility";
    mainProgram = "icesprog";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    homepage = "https://github.com/wuxx/icesugar";
  };
})
