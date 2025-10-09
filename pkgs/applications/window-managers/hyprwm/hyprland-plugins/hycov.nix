{
  lib,
  mkHyprlandPlugin,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hycov";
  version = "0.41.2.1";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "hycov";
    tag = finalAttrs.version;
    hash = "sha256-NRnxbkuiq1rQ+uauo7D+CEe73iGqxsWxTQa+1SEPnXQ=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clients overview for Hyprland plugin";
    homepage = "https://github.com/DreamMaoMao/hycov";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
    broken = true; # Doesn't work after Hyprland v0.41.2 https://gitee.com/DreamMaoMao/hycov/issues/IANYC8#note_31512295_link
  };
})
