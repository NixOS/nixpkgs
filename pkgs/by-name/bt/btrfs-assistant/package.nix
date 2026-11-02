{
  lib,
  stdenv,
  fetchFromGitLab,
  btrfs-progs,
  cmake,
  coreutils,
  diffutils,
  git,
  pkg-config,
  qt6,
  snapper,
  util-linux,
  enableSnapper ? true,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-assistant";
  version = "3.0.0";

  src = fetchFromGitLab {
    owner = "btrfs-assistant";
    repo = "btrfs-assistant";
    rev = finalAttrs.version;
    hash = "sha256-FYSpsDLXmf2NBR97+M59ECmE3ClTlQCWm+mmxY8r/mw=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    btrfs-progs
    coreutils
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    util-linux
  ]
  ++ lib.optionals enableSnapper [ snapper ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail '/usr/share/btrfs-assistant/translations' "$out/share/btrfs-assistant/translations"

    substituteInPlace src/helper/main.cpp \
      --replace-fail '/usr/bin:/usr/sbin:/bin:/sbin' "${
        lib.makeBinPath (
          [
            btrfs-progs
            util-linux
            diffutils
          ]
          ++ lib.optionals enableSnapper [ snapper ]
        )
      }"
  ''
  + lib.optionalString enableSnapper ''
    substituteInPlace src/core/CoreService.cpp \
      --replace-fail '/usr/bin/snapper' "${lib.getExe snapper}"

    substituteInPlace src/btrfs-assistant.conf \
      --replace-fail '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI management tool to make managing a Btrfs filesystem easier";
    homepage = "https://gitlab.com/btrfs-assistant/btrfs-assistant";
    changelog = "https://gitlab.com/btrfs-assistant/btrfs-assistant/-/blob/${finalAttrs.version}/changelog";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrfs-assistant";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
