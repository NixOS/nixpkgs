{
  lib,
  stdenv,
  buildComfyUICustomNode,
  fetchFromGitHub,
}:

buildComfyUICustomNode (finalAttrs: {
  pname = "comfyui-crystools";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "crystian";
    repo = "ComfyUI-Crystools";
    tag = "1.26.0";
    hash = "sha256-YMDt9+QXF7QpCajwRXYx6GEJDdRXFOo2fnQXUqNviVE=";
  };

  installName = "ComfyUI-Crystools";

  # Crystools 1.26.0 targets the old ComfyUI menu;
  # the current frontend places the monitor in .actionbar-container and the CSS no longer matches.
  # Backport the upstream "fixed new ui" commit (2f18256c5b50) so the monitor is styled.
  # Drop this when 1.27.4 is released and the package is bumped.
  postPatch = ''
    substituteInPlace web/styles.js \
      --replace-fail 'extensions/comfyui-crystools/monitor.css' 'extensions/ComfyUI-Crystools/monitor.css'
    substituteInPlace web/monitor.css \
      --replace-fail '.comfyui-menu #crystools-monitors-root {' '#crystools-monitors-root {'
    substituteInPlace web/monitorUI.js \
      --replace-fail '.comfyui-menu #crystools-monitors-root .crystools-monitor .crystools-content' '#crystools-monitors-root .crystools-monitor .crystools-content'
  '';

  # torch, numpy, Pillow and psutil are already part of ComfyUI's environment.
  pythonDeps =
    ps:
    with ps;
    [
      deepdiff
      piexif
      py-cpuinfo
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isAarch64) [ pynvml ];

  meta = {
    description = "Resource monitor, progress bar, metadata tools and debugging nodes for ComfyUI";
    homepage = "https://github.com/crystian/ComfyUI-Crystools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightfemale ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
