{ stdenv, fetchurl, substituteAll, python3, gst_all_1, wrapGAppsHook, gobject-introspection
, gtk3, libwnck3, keybinder3, intltool, libcanberra-gtk3, libappindicator-gtk3, libpulseaudio
, fetchpatch }:

python3.pkgs.buildPythonApplication rec {
  name = "kazam-${version}";
  version = "1.4.5";
  namePrefix = "";

  src = fetchurl {
    url = "https://launchpad.net/kazam/stable/${version}/+download/kazam-${version}.tar.gz";
    sha256 = "1qygnrvm6aqixbyivhssp70hs0llxwk7lh3j7idxa2jbkk06hj4f";
  };

  nativeBuildInputs = [ gobject-introspection python3.pkgs.distutils_extra intltool wrapGAppsHook ];
  buildInputs = [
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gtk3 libwnck3
    keybinder3 libappindicator-gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 pyxdg pycairo dbus-python ];
 
  # workaround https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  patches = [
    # Fix paths
    (substituteAll {
      src = ./fix-paths.patch;
      libcanberra = libcanberra-gtk3;
      inherit libpulseaudio;
    })
    # https://github.com/hzbd/kazam/pull/21
    (fetchpatch {
      url = https://github.com/hzbd/kazam/commit/37e53a5aa61f4223a9ea03ceeda26eeba2b9d37b.patch;
      sha256 = "1q5dpmdm6cvgzw8xa7bwclnqa05xc73ja1lszwmwv5glyik0fk4z";
    })
  ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A screencasting program created with design in mind";
    homepage = https://code.launchpad.net/kazam;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
