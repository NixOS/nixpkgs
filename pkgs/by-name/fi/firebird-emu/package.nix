{
  stdenv,
  lib,
  fetchFromGitHub,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "firebird-emu";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "nspire-emus";
    repo = "firebird";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZptjlnOiF+hKuKYvBFJL95H5YQuR99d4biOco/MVEmE=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtquickcontrols
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/firebird-emu.app $out/Applications/
  '';

  meta = {
    homepage = "https://github.com/nspire-emus/firebird";
    changelog = "https://github.com/nspire-emus/firebird/releases/tag/v${finalAttrs.version}";
    description = "Third-party multi-platform emulator of the ARM-based TI-Nspire™ calculators";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
