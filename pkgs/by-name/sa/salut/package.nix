{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, fontconfig
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "salut";
  version = "unstable-2022-12-17";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "salut";
    rev = "aa57c4d190812908a9c32cd49cff14390c6dfdcb";
    hash = "sha256-W0lhhImSXtYJDeMbxyEioYu/Bh7ZclwR1/5DzNbxM8o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "msg-api-0.1.0" = "sha256-SGEr9kitvD+KZPGejwDAISK6ERk7G2uskxX8ljiJ2To=";
      "smithay-client-toolkit-0.16.0" = "sha256-kiTO+BZIgpuwAr6gs9FCqz81jRg+3dV4NxzOX9kbJOc=";
      "snui-0.1.4" = "sha256-jJL9ukSOczHjPM2EAXcXcz620SK4DQfr+xAT8v7fp9o=";
      "snui-adwaita-0.1.0" = "sha256-pILhLMzqnhLZfGAXT8QQn6x+IvwG7CSa96wZqq1yrLY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libxkbcommon
    wayland
  ];

  meta = {
    description = "Sleek notification daemon for Wayland";
    homepage = "https://gitlab.com/snakedye/salut/-/wikis/Home";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "salut";
    platforms = lib.platforms.linux;
  };
}
