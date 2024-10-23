{
  buildLua,
  fetchFromGitHub,
  lib,
  newScope,
  unstableGitUpdater,
}:
lib.makeScope newScope (
  self: with self; {
    mkScript =
      scriptName:
      buildLua {
        pname = scriptName;
        version = "0-unstable-2023-03-03";
        src = fetchFromGitHub {
          owner = "occivink";
          repo = "mpv-image-viewer";
          rev = "efc82147cba4809f22e9afae6ed7a41ad9794ffd";
          hash = "sha256-H7uBwrIb5uNEr3m+rHED/hO2CHypGu7hbcRpC30am2Q=";
        };
        sourceRoot = "source/scripts";

        passthru = {
          updateScript = unstableGitUpdater { };
        };

        meta = {
          description = "configuration, scripts and tips for using mpv as an image viewer";
          longDescription = ''
            mpv-image-viewer aggregates configurations, scripts and tips for using
            mpv as an image viewer. The affectionate nickname mvi is given to mpv in
            such case.

            Each mpv-image-viewer script can be used on its own without depending on
            any of the others. Refer to the README and script-opts/ directory for
            additional configuration tips or examples.
          '';
          homepage = "https://github.com/occivink/mpv-image-viewer";
          license = with lib.licenses; [ unlicense ];
          maintainers = with lib.maintainers; [ colinsane ];
        };
      };

    detect-image = mkScript "detect-image";
    equalizer = mkScript "equalizer";
    freeze-window = mkScript "freeze-window";
    image-positioning = mkScript "image-positioning";
    minimap = mkScript "minimap";
    ruler = mkScript "ruler";
    status-line = mkScript "status-line";
  }
)
