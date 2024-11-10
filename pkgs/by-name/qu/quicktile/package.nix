{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  libwnck,
  gtk3,
  nix-update-script,
}:
let
  version = "0.4.0";
in
python3.pkgs.buildPythonApplication {
  pname = "quicktile";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssokolow";
    repo = "quicktile";
    rev = "refs/tags/v${version}";
    hash = "sha256-YDTIjjRpMopVnI7CvtfvMPzdCPRfDEn/zS18niWe58g=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    libwnck
    gtk3
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    xlib
    dbus-python
  ];

  pythonImportsCheck = [ "quicktile" ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    distutils
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-driven Window Tiling for your existing X11 window manager";
    homepage = "https://ssokolow.com/quicktile/";
    changelog = "https://github.com/ssokolow/quicktile/blob/v${version}/ChangeLog";
    license = with lib.licenses; [ gpl2Plus ];
    # Darwin support is not officially supported so use at your own risk
    # https://ssokolow.com/quicktile/faq.html#does-quicktile-run-on-macos
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "quicktile";
  };
}
