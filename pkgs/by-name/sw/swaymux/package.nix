{
  cmake,
  fetchFromGitea,
  lib,
  nlohmann_json,
  qt6,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.1";
  pname = "swaymux";

  src = fetchFromGitea {
    rev = "v${finalAttrs.version}";
    domain = "git.grimmauld.de";
    owner = "Grimmauld";
    repo = "swaymux";
    hash = "sha256-OMJ9wKNuvD1Z9KV7Bp7aIA5gWbBl9PmTdGcGegE0vqM=";
  };

  buildInputs = [
    qt6.qtwayland
    nlohmann_json
    qt6.qtbase
  ];
  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  doCheck = true;

  meta = {
    changelog = "https://git.grimmauld.de/Grimmauld/swaymux/commits/branch/main";
    description = "Program to quickly navigate sway";
    homepage = "https://git.grimmauld.de/Grimmauld/swaymux";
    license = lib.licenses.bsd3;
    longDescription = ''
      Swaymux allows the user to quickly navigate and administrate outputs, workspaces and containers in a tmux-style approach.
    '';
    mainProgram = "swaymux";
    maintainers = with lib.maintainers; [ grimmauld ];
    platforms = lib.platforms.linux;
  };
})
