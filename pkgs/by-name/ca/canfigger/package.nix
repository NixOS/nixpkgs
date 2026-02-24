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

  # canfigger has asan and ubsan enabled by default, disable it here
  mesonFlags = [
    "-Dcanfigger:b_sanitize=none"
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
