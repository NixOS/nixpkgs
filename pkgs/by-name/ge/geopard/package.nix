{ stdenv
, cargo
, rustc
, fetchFromGitHub
, libadwaita
, rustPlatform
, pkg-config
, lib
, wrapGAppsHook4
, meson
, ninja
, desktop-file-utils
, blueprint-compiler
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "geopard";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "geopard";
    rev = "v${version}";
    hash = "sha256-QHqhjoiKiwTBDMDhb7Agqe0/o2LyLDs2kl/HC4UfayY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-AmGwsSRrZK+oSnkn9Xzmia/Kbkw19v0nb1kFJtymqOs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libadwaita
    glib-networking
  ];

  meta = with lib; {
    homepage = "https://github.com/ranfdev/Geopard";
    description = "Colorful, adaptive gemini browser";
    maintainers = with maintainers; [ jfvillablanca aleksana ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "geopard";
  };
}
