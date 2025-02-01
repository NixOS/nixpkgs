{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-filtile";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pkulak";
    repo = "filtile";
    rev = "v${version}";
    hash = "sha256-wBU4CX6KGnTvrBsXvFAlRrvDqvHHbAlVkDqTCJx90G8=";
  };

  cargoHash = "sha256-W5e19gzkZZjTTSZdww2x7M0LnR/gClQxMeAiDITO3HY=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pkulak ];
    mainProgram = "filtile";
  };
}
