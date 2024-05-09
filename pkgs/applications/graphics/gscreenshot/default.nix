{ lib
, fetchFromGitHub
, python3Packages
, gettext
, gobject-introspection
, gtk3
, wrapGAppsHook3
, xdg-utils
, scrot
, slop
, xclip
, grim
, slurp
, wl-clipboard
, waylandSupport ? true
, x11Support ? true
}:

python3Packages.buildPythonApplication rec {
  pname = "gscreenshot";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "thenaterhood";
    repo = "${pname}";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-BA118PwMslqvnlRES2fEgTjzfNvKNVae7GzWSyuaqYM=";
  };

  # needed for wrapGAppsHook3 to function
  strictDeps = false;
  # tests require a display and fail
  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook3 ];
  propagatedBuildInputs = [
    gettext
    gobject-introspection
    gtk3
    xdg-utils
  ] ++ lib.optionals waylandSupport [
    # wayland deps
    grim
    slurp
    wl-clipboard
  ] ++ lib.optionals x11Support [
    # X11 deps
    scrot
    slop
    xclip
    python3Packages.xlib
  ] ++ (with python3Packages; [
    pillow
    pygobject3
    setuptools
  ]);

  patches = [ ./0001-Changing-paths-to-be-nix-compatible.patch ];

  meta = {
    description = "A screenshot frontend (CLI and GUI) for a variety of screenshot backends";

    longDescription = ''
      gscreenshot provides a common frontend and expanded functionality to a
      number of X11 and Wayland screenshot and region selection utilities.

      In a nutshell, gscreenshot supports the following:

      - Capturing a full-screen screenshot
      - Capturing a region of the screen interactively
      - Capturing a window interactively
      - Capturing the cursor
      - Capturing the cursor, using an alternate cursor glyph
      - Capturing a screenshot with a delay
      - Showing a notification when a screenshot is taken
      - Capturing a screenshot from the command line or a custom script
      - Capturing a screenshot using a GUI
      - Saving to a variety of image formats including 'bmp', 'eps', 'gif', 'jpeg', 'pcx', 'pdf', 'ppm', 'tiff', 'png', and 'webp'.
      - Copying a screenshot to the system clipboard
      - Opening a screenshot in the configured application after capture

      Other than region selection, gscreenshot's CLI is non-interactive and is suitable for use in scripts.
    '';

    homepage = "https://github.com/thenaterhood/gscreenshot";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.davisrichard437 ];
  };
}
