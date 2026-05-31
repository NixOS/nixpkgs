{
  buildLua,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:
let
  mkScript =
    pname: args:
    let
      self = {
        inherit pname;
        version = "0-unstable-2024-11-23";
        src = fetchFromGitHub {
          owner = "occivink";
          repo = "mpv-image-viewer";
          rev = "128b498e3e57a14deea5ca9bbf662f8c1ca79e8d";
          hash = "sha256-VwIL1529CW9MLK4N9jHHddSSZD5RsJ5bWGWqGJ751C0=";
        };

        sourceRoot = "${self.src.name}/scripts";

        passthru = {
          updateScript = unstableGitUpdater { };
        };

        meta = {
          description = "Configuration, scripts and tips for using mpv as an image viewer";
          longDescription = ''
            ${pname} is a component of mpv-image-viewer.

            mpv-image-viewer aggregates configurations, scripts and tips for using
            mpv as an image viewer. The affectionate nickname mvi is given to mpv in
            such case.

            Each mpv-image-viewer script can be used on its own without depending on
            any of the others. Refer to the README and script-opts/ directory for
            additional configuration tips or examples.
          '';
          homepage = "https://github.com/occivink/mpv-image-viewer";
          license = lib.licenses.unlicense;
          maintainers = with lib.maintainers; [ colinsane ];
        };
      };
    in
    buildLua (lib.attrsets.recursiveUpdate self args);
in
lib.recurseIntoAttrs (
  lib.mapAttrs (name: lib.makeOverridable (mkScript name)) {
    detect-image.meta.description = "Allows you to run specific commands when images are being displayed. Does not do anything by default, needs to be configured through detect_image.conf";
    equalizer = { };
    freeze-window.meta.description = "By default, mpv automatically resizes the window when the current file changes to fit its size. This script freezes the window so that this does not happen. There is no configuration";
    image-positioning.meta.description = "Adds several high-level commands to zoom and pan";
    minimap.meta.description = "Adds a minimap that displays the position of the image relative to the view";
    ruler.meta.description = "Adds a ruler command that lets you measure positions, distances and angles in the image. Can be configured through ruler.conf";
    status-line.meta.description = "Adds a status line that can show different properties in the corner of the window. By default it shows filename [positon/total] in the bottom left";
  }
)
