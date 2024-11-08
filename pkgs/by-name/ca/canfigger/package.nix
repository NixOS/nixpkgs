{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "canfigger";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "andy5995";
    repo = "canfigger";
    rev = "v${version}";
    hash = "sha256-S2rEQT8wKSjJ7LFF6vcigqb9r5QR/nNUCzNdhuBNjTo=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Lightweight library designed to parse configuration files";
    homepage = "https://github.com/andy5995/canfigger";
    changelog = "https://github.com/andy5995/canfigger/blob/${src.rev}/ChangeLog.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "canfigger";
    platforms = lib.platforms.all;
  };
}
