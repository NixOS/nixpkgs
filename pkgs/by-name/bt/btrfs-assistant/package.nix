{
  lib,
  stdenv,
  fetchFromGitLab,
  bash,
  btrfs-progs,
  cmake,
  coreutils,
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
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "btrfs-assistant";
    repo = "btrfs-assistant";
    rev = finalAttrs.version;
    hash = "sha256-I4nbQmHwk84qN1SngKzKnPtQN5Dz1QSSEpHJxV8wkJw=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    btrfs-progs
    coreutils
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    util-linux
  ] ++ lib.optionals enableSnapper [ snapper ];

  prePatch =
    ''
      substituteInPlace src/util/System.cpp \
        --replace-fail '/bin/bash' "${lib.getExe bash}"

      substituteInPlace src/main.cpp \
        --replace-fail 'if (!qEnvironmentVariableIsEmpty("DISPLAY"))' ' if(!qEnvironmentVariableIsEmpty("DISPLAY") || !qEnvironmentVariableIsEmpty("WAYLAND_DISPLAY"))'
    ''
    + lib.optionalString enableSnapper ''
      substituteInPlace src/main.cpp \
        --replace-fail '/usr/bin/snapper' "${lib.getExe snapper}"
    '';

  postPatch =
    ''
      substituteInPlace src/org.btrfs-assistant.pkexec.policy \
        --replace-fail '/usr/bin' "$out/bin"

      substituteInPlace src/btrfs-assistant \
        --replace-fail 'btrfs-assistant-bin' "$out/bin/btrfs-assistant-bin"

      substituteInPlace src/btrfs-assistant-launcher \
        --replace-fail 'btrfs-assistant' "$out/bin/btrfs-assistant"
    ''
    + lib.optionalString enableSnapper ''
      substituteInPlace src/btrfs-assistant.conf \
        --replace-fail '/usr/bin/snapper' "${lib.getExe snapper}"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI management tool to make managing a Btrfs filesystem easier";
    homepage = "https://gitlab.com/btrfs-assistant/btrfs-assistant";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrfs-assistant-bin";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
