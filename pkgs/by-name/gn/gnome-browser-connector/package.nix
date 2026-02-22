{
  lib,
  fetchurl,
  meson,
  ninja,
  python3,
  gnome,
  gnome-shell,
  wrapGAppsNoGuiHook,
  gobject-introspection,
}:

let
  inherit (python3.pkgs) buildPythonApplication pygobject3;
in
buildPythonApplication (finalAttrs: {
  pname = "gnome-browser-connector";
  version = "42.1";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-browser-connector/${lib.versions.major finalAttrs.version}/gnome-browser-connector-${finalAttrs.version}.tar.xz";
    sha256 = "vZcCzhwWNgbKMrjBPR87pugrJHz4eqxgYQtBHfFVYhI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsNoGuiHook
    gobject-introspection # for setup-hook
  ];

  buildInputs = [
    gnome-shell
  ];

  pythonPath = [
    pygobject3
  ];

  postPatch = ''
    patchShebangs contrib/merge_json.py
  '';

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-browser-connector";
    };
  };

  meta = {
    description = "Native host connector for the GNOME Shell browser extension";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-browser-connector";
    longDescription = ''
      To use the integration, install the [browser extension](https://gitlab.gnome.org/GNOME/gnome-browser-extension), and then set `services.gnome.gnome-browser-connector.enable` to `true`.
    '';
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
