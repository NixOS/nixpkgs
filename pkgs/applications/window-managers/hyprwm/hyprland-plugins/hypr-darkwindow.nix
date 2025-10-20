{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hypr-darkwindow";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "micha4w";
    repo = "Hypr-DarkWindow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jq5j459gCVuBOpuGEvXe+9/O+HAineFxQI4sIcEPi/c=";
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
