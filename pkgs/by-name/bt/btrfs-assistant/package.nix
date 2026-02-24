{
  lib,
  stdenv,
  fetchFromGitLab,
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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-assistant";
  version = "2.2";

  src = fetchFromGitLab {
    owner = "btrfs-assistant";
    repo = "btrfs-assistant";
    rev = finalAttrs.version;
    hash = "sha256-hFWYT+YIgnqBigpPkGdsLj6rcg4CjJffAyXlR23QP0Y=";
  };

  patches = [
    # Disable -Werror
    # https://gitlab.com/btrfs-assistant/btrfs-assistant/-/issues/134
    (fetchpatch {
      url = "https://gitlab.com/btrfs-assistant/btrfs-assistant/-/commit/edc0a13bac5189a1a910f5adab01b2d5b60c76f6.diff";
      hash = "sha256-kGyp5OaSGk4OvhtyNSygJEW+wAJksK8opxtLPbhA+10=";
    })
  ];

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
  ]
  ++ lib.optionals enableSnapper [ snapper ];

  prePatch = lib.optionalString enableSnapper ''
    substituteInPlace src/main.cpp \
      --replace-fail '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  postPatch = ''
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
