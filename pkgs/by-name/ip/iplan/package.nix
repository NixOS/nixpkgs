{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "iplan";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "iman-salmani";
    repo = "iplan";
    rev = "v${version}";
    hash = "sha256-BIoxaE8c3HmvPjgj4wcZK9YFTZ0wr9338AIdYEoAiqs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-p8ETWWvjtP9f/lc347ORPqTai5p/TWQCCMRe+c0FyFk=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  meta = with lib; {
    description = "Your plan for improving personal life and workflow";
    homepage = "https://github.com/iman-salmani/iplan";
    license = licenses.gpl3Plus;
    mainProgram = "iplan";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
