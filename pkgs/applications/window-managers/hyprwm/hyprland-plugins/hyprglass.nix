{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprglass";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yUU0gKu1CXqpUQBtyb3IWNBYZ1bCAm99mfTUV7ceJyg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprglass.so "$out/lib/libhyprglass.so"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugin to add effects inspired by liquid glass design to transparent windows.";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Username404-59 ];
    platforms = lib.platforms.linux;
  };
})
