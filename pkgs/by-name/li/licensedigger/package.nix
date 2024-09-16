{
  lib,
  fetchFromGitLab,
  stdenv,
  cmake,
  kdePackages,
  libsForQt5,
}:
stdenv.mkDerivation {
  pname = "licensedigger";
  version = "0-unstable-2024-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "SDK";
    repo = "licensedigger";
    rev = "cc4b24d3fb67afa8fb0a9ef61210588958eaf0f5";
    hash = "sha256-/ZEja+iDx0lVkJaLshPd1tZD4ZUspVeFHY1TNXjr4qg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    libsForQt5.qtbase
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Tools to convert existing license headers to SPDX compliant headers";
    homepage = "https://invent.kde.org/sdk/licensedigger";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ onny ];
  };
}
