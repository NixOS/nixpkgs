{ lib
, stdenv
, fetchFromGitLab
, bash
, btrfs-progs
, cmake
, coreutils
, git
, pkg-config
, qt6
, snapper
, util-linux
, enableSnapper ? true
, nix-update-script
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
  ];

  buildInputs = [
    btrfs-progs
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
  ];

  propagatedBuildInputs = [ qt6.wrapQtAppsHook ];

  prePatch = ''
    substituteInPlace src/util/System.cpp \
      --replace '/bin/bash' "${lib.getExe bash}"
  ''
  + lib.optionalString enableSnapper ''
    substituteInPlace src/main.cpp \
      --replace '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  postPatch = ''
    substituteInPlace src/org.btrfs-assistant.pkexec.policy \
      --replace '/usr/bin' "$out/bin"

    substituteInPlace src/btrfs-assistant \
      --replace 'btrfs-assistant-bin' "$out/bin/btrfs-assistant-bin"

    substituteInPlace src/btrfs-assistant-launcher \
      --replace 'btrfs-assistant' "$out/bin/btrfs-assistant"
  ''
  + lib.optionalString enableSnapper ''
    substituteInPlace src/btrfs-assistant.conf \
      --replace '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  qtWrapperArgs =
    let
      runtimeDeps = lib.makeBinPath ([
        coreutils
        util-linux
      ]
      ++ lib.optionals enableSnapper [ snapper ]);
    in
    [
      "--prefix PATH : ${runtimeDeps}"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A GUI management tool to make managing a Btrfs filesystem easier";
    homepage = "https://gitlab.com/btrfs-assistant/btrfs-assistant";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrfs-assistant-bin";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
