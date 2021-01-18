{ lib
, callPackage
, fetchFromGitHub
, gettext
, xorg # for lndir
, gtk3
, python3Packages
, gdk-pixbuf
, libnotify
, gst_all_1
, libsecret
, wrapGAppsHook
, gsettings-desktop-schemas
, glib
, gobject-introspection
# Available plugins (can be overriden)
, availablePlugins
# Used in the withPlugins interface at passthru, can be overrided directly, or
# prefarably via e.g: `mailnag.withPlugins([mailnag.availablePlugins.goa])`
, mailnag
, userPlugins ? [ ]
, pluginsDeps ? [ ]
}:

python3Packages.buildPythonApplication rec {
  pname = "mailnag";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pulb";
    repo = "mailnag";
    rev = "v${version}";
    sha256 = "08jqs3v01a9gkjca9xgjidhdgvnlm4541z9bwh9m3k5p2g76sz96";
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    libnotify
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gobject-introspection
    libsecret
  ] ++ pluginsDeps;

  nativeBuildInputs = [
    gettext
    wrapGAppsHook
    # To later add plugins to
    xorg.lndir
  ];

  propagatedBuildInputs = with python3Packages; [
    gsettings-desktop-schemas
    pygobject3
    dbus-python
    pyxdg
  ];

  passthru = {
    inherit availablePlugins;
    withPlugins =
      plugs:
      let
        # goa plugin requires gio's gnome-online-accounts which requires making sure
        # mailnag runs with GI_TYPELIB_PATH containing the path to Goa-1.0.typelib.
        # This is handled best by adding the plugins' deps to buildInputs and let
        # wrapGAppsHook handle that.
        pluginsDeps = lib.flatten (lib.catAttrs "buildInputs" plugs);
        self = mailnag;
      in
        self.override {
          userPlugins = plugs;
          inherit pluginsDeps;
        };
  };

  # See https://nixos.org/nixpkgs/manual/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;

  preFixup = ''
    substituteInPlace $out/${python3Packages.python.sitePackages}/Mailnag/common/dist_cfg.py \
      --replace "/usr/" $out/
    for desktop_file in $out/share/applications/*.desktop; do
      substituteInPlace "$desktop_file" \
      --replace "/usr/bin" $out/bin
    done
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Actually install plugins
  postInstall = ''
    for plug in ${builtins.toString userPlugins}; do
      lndir $plug/${python3Packages.python.sitePackages} $out/${python3Packages.python.sitePackages}
    done
  '';

  meta = with lib; {
    description = "An extensible mail notification daemon";
    homepage = "https://github.com/pulb/mailnag";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
