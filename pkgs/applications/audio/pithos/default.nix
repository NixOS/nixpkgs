# Based on Richard Wallace's post here: http://comments.gmane.org/gmane.linux.distributions.nixos/14734

{ fetchurl, stdenv, pythonPackages, gtk3, libnotify, gst_all_1 }:
pythonPackages.buildPythonPackage rec {
  name = "pithos-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/pithos/pithos/archive/${version}.tar.gz";
    sha256 = "67b83927d5111067aefbf034d23880f96b1a2d300464e8491efa80e97e67f50f";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "/usr/share" "$out/share"
  '';

  buildInputs = with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad libnotify ];

  pythonPath = with pythonPackages; [ pygobject3 dbus pylast ];

  propogatedBuildInputs = pythonPath;

  postInstall = ''
    wrapProgram "$out/bin/pithos" --prefix GST_PLUGIN_SYSTEM_PATH_1_0 ":" "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = with stdenv.lib; {
    description = "Pandora player";

    longDescription = ''
      Pandora Internet Radio player for GNOME
    '';

    homepage = http://pithos.github.io/ ;

    license = licenses.gpl3;

    maintainers = with maintainers; [ obadz ];
  };
}
