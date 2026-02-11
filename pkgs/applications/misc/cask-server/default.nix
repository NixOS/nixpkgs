{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "cask-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = "cask-server";
    tag = "v${version}";
    sha256 = "sha256-XUgLtZMcvzGewtUcgu7FbBCn/1zqOjWvw2AI9gUwWkc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  meta = {
    description = "Public server and API to interface with Cask features";
    mainProgram = "CaskServer";
    homepage = "https://github.com/Nitrux/cask-server";
    license = with lib.licenses; [
      bsd2
      lgpl21Plus
      cc0
    ];
    maintainers = with lib.maintainers; [ onny ];
  };

}
