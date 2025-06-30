# Start this shell with:
# nix-shell path/to/root/of/nixpkgs -A flattenReferencesGraph.dev-shell
{
  mkShell,
  callPackage,
  python3Packages,
}:
let
  helpers = callPackage (import ./helpers.nix) { };
in
mkShell {
  inputsFrom = [ (callPackage (import ./package.nix) { }) ];
  buildInputs = [
    helpers.format
    helpers.lint
    helpers.unittest
    # This is needed to plot graphs when DEBUG_PLOT is set to True.
    python3Packages.pycairo
    # This can be used on linux to display the graphs.
    # On other platforms the image viewer needs to be set with
    # DEBUG_PLOT_IMAGE_VIEWER env var.
    # pkgs.gwenview
  ];
  shellHook = ''
    echo '
    **********************************************************************
    **********************************************************************

      Commands useful for development (should be executed from scr dir):


      format
        * formats all files in place using autopep8

      lint
        * lints all files using flake8

      unittest
        * runs all unit tests

          following env vars can be set to enable extra output in tests:
          - DEBUG=True - enable debug logging
          - DEBUG_PLOT=True - plot graphs processed by split_paths.py and
              subcomponent.py
          - DEBUG_PLOT_IMAGE_VIEWER=$PATH_OF_IMAGE_VIEWER_APP - app used to
              display plots (default: gwenview)
          - DEBUG_PLOT_SAVE_BASE_NAME=$SOME_NAME - if set, plots will be saved
              to files instead of displayed with image viewer

    **********************************************************************
    **********************************************************************
    '
  '';
}
