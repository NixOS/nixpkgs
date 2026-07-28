{
  lib,
  stdenv,
  qt5,
  libsForQt5,
  fetchgit,
  cmake,
  libsecret,
  restic,
}:

stdenv.mkDerivation {
  pname = "restique";
  version = "0-unstable-2024-10-20";

  # using fetchFromGitea returns 404
  src = fetchgit {
    url = "https://git.srcbox.net/stefan/restique";
    rev = "340d8326c2a2221ec155512cc6ffb2c8a866c525";
    hash = "sha256-IBg8hRJ7nugHP+JLg0fTONgZ+oRdkJpeZzflrwSG20w=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsecret
    libsForQt5.qtkeychain
    qt5.qttools
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ restic ])
  ];

  meta = {
    description = "Restic GUI for Desktop/Laptop Backups";
    homepage = "https://git.srcbox.net/stefan/restique";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-40
      cc0
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "restique";
  };
}
