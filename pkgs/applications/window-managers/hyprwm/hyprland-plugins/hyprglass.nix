{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
  wayland-scanner,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprglass";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jq47p3kJ3N/qw8E83lIewjg9hp7oJw9iIYzMT+YPXic=";
  };

  nativeBuildInputs = [ wayland-scanner ];

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
