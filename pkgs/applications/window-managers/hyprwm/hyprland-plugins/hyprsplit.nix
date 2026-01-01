{
  lib,
  meson,
  fetchFromGitHub,
  ninja,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprsplit";
<<<<<<< HEAD
  version = "0.52.2";
=======
  version = "0.52.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6s8nuPwLP5NKUevLeYYgHirk9RkZhaXtDRXBfrIAibs=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/shezdy/hyprsplit";
    description = "Hyprland plugin for awesome / dwm like workspaces";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aacebedo
    ];
  };
})
