{
  lib,
  fetchFromGitLab,
  stdenv,
  cmake,
  kdePackages,
  qt6,
}:
stdenv.mkDerivation {
  pname = "licensedigger";
  version = "0-unstable-2025-08-19";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "SDK";
    repo = "licensedigger";
    rev = "711236617bfdeb4f72fecec3ab29bc25806337e5";
    hash = "sha256-IuH7K2Hhhdzw01fypiabv8/tClt+0rr4j94JAy8VKN4=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

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
