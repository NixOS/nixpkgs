{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
  cmake,
  ninja,
  qt6,
  procps,
  xorg,
  steam,
  useNixSteam ? true,
}:

let
  inherit (kdePackages) qtbase wrapQtAppsHook;
  qtEnv =
    with qt6;
    env "qt-env-custom-${qtbase.version}" [
      qthttpserver
      qtwebsockets
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "moondeck-buddy";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "FrogTheFrog";
    repo = "moondeck-buddy";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-CcORcojz3jh1UZpq5qjDv+YktXC+F8t+r7E1SFyFkmw=";
  };

  buildInputs = [
    procps
    xorg.libXrandr
    qtbase
    qtEnv
  ];
  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  postPatch = lib.optionalString useNixSteam ''
    substituteInPlace src/lib/os/linux/steamregistryobserver.cpp \
      --replace-fail /usr/bin/steam ${lib.getExe steam};
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "MoonDeckBuddy";
    description = "Helper to work with moonlight on a steamdeck";
    homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
    changelog = "https://github.com/FrogTheFrog/moondeck-buddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ redxtech ];
    platforms = lib.platforms.linux;
  };
})
