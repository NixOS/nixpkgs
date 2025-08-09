{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-utils";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "utils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XiOLVx9X2i+IWORde05P2cFulQRU/EQErbyr5fgZDY4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Some utilities for DFL";
    homepage = "https://gitlab.com/desktop-frameworks/utils";
    changelog = "https://gitlab.com/desktop-frameworks/utils/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.linux;
  };
})
