{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hypr-darkwindow";
  version = "0.55.4";

  src = fetchFromGitHub {
    owner = "micha4w";
    repo = "Hypr-DarkWindow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-91l5TD46OMfvmhd1WqWxm42cEnjR1yAj2Qk/73mr3ks=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv out/hypr-darkwindow.so $out/lib/libhypr-darkwindow.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland Plugin to invert Colors of specific Windows!";
    homepage = "https://github.com/micha4w/Hypr-DarkWindow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
})
