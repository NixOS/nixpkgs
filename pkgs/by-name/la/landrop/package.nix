{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "landrop";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "LANDrop";
    repo = "LANDrop";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IwtphjMSa0e2mO5C4zHId48SUpT99sXziZzApnSmvrU=";
  };

  sourceRoot = "${finalAttrs.src.name}/LANDrop";

  postPatch = ''
    substituteInPlace LANDrop.pro \
        --replace-fail '$$(PREFIX)' '$$PREFIX'
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtwayland
    libsodium
  ];

  meta = {
    changelog = "https://github.com/LANDrop/LANDrop/releases/tag/v${finalAttrs.version}";
    description = "Utility for transferring files to other devices on the same local network";
    homepage = "https://landrop.app";
    license = with lib.licenses; [
      bsd3
      cc-by-nc-nd-40 # icon
    ];
    mainProgram = "landrop";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
