{ stdenv, fetchurl, python, buildPythonPackage, mutagen, pygtk, pygobject
, pythonDBus, gst_python, gst_plugins_base, gst_plugins_good, gst_plugins_ugly }:

let version = "2.5"; in

buildPythonPackage {
  # call the package quodlibet and just quodlibet
  name = "quodlibet-${version}";
  namePrefix = "";

  # XXX, tests fail
  doCheck = false;

  src = [
    (fetchurl {
      url = "https://quodlibet.googlecode.com/files/quodlibet-${version}.tar.gz";
      sha256 = "0qrmlz7m1jpmriy8bgycjiwzbf3annznkn4x5k32yy9bylxa7lwb";
     })
    (fetchurl {
      url = "https://quodlibet.googlecode.com/files/quodlibet-plugins-${version}.tar.gz";
      sha256 = "0kf2mkq2zk38626bn48gscvy6ir04f5b2z57ahlxlqy8imv2cjff";
     })
  ];       

  sourceRoot = "quodlibet-${version}";
  postUnpack = ''
    # the patch searches for plugins in directory ../plugins
    # so link the appropriate directory there
    ln -sf quodlibet-plugins-${version} plugins
  '';
  patches = [ ./quodlibet-package-plugins.patch ];

  buildInputs = [
    gst_plugins_base gst_plugins_good gst_plugins_ugly
  ];

  propagatedBuildInputs = [
    mutagen pygtk pygobject pythonDBus gst_python
  ];

  postInstall = ''
    # Wrap quodlibet so it finds the GStreamer plug-ins
    wrapProgram "$out/bin/quodlibet" --prefix                                 \
      GST_PLUGIN_PATH ":"                                                     \
      "${gst_plugins_base}/lib/gstreamer-0.10:${gst_plugins_good}/lib/gstreamer-0.10:${gst_plugins_ugly}/lib/gstreamer-0.10"
  '';

  meta = {
    description = "GTK+-based audio player written in Python, using the Mutagen tagging library";

    longDescription = ''
      Quod Libet is a GTK+-based audio player written in Python, using
      the Mutagen tagging library. It's designed around the idea that
      you know how to organize your music better than we do. It lets
      you make playlists based on regular expressions (don't worry,
      regular searches work too). It lets you display and edit any
      tags you want in the file. And it lets you do this for all the
      file formats it supports. Quod Libet easily scales to libraries
      of thousands (or even tens of thousands) of songs. It also
      supports most of the features you expect from a modern media
      player, like Unicode support, tag editing, Replay Gain, podcasts
      & internet radio, and all major audio formats.
    '';

    homepage = http://code.google.com/p/quodlibet/;
  };
}
