{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  gtk3,
  jansson,
  luajit,
  meson,
  ninja,
  pkg-config,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

gcc15Stdenv.mkDerivation {
  pname = "libresplit";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    rev = "f87a6829c9319acca907a39af4d391375a322713";
    hash = "sha256-wcv4VkuVClc+yCe/o8hIQFO/mxF4NAB7et52SLOwgpk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
    luajit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/LibreSplitDev/LibreSplit";
    description = "Speedrun timer with auto splitting and load removal for Linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "libresplit";
    platforms = lib.platforms.linux;
  };
}
