{ stdenv, fetchgit, autoconf, automake, libtool, makeWrapper
, python, pygobject, intltool }:

stdenv.mkDerivation rec {
  name = "transmageddon-0.22";

  preConfigure = "autoreconf -vfi";

  src = fetchgit {
    url = git://git.gnome.org/transmageddon;
    rev = "8b1eedadae484b3fb6599d27ff4cbe9ec5e3a3b9";
    sha256 = "97567a3e26e54d10f28374b514fdee5d87776d185b56c6b74c1eb0dae11bc5a8";
  };

  pythonPath = [ pygobject ];

  postInstall = ''
    wrapProgram "$out/bin/transmageddon" \
      --set PYTHONPATH $(toPythonPath "${pygobject}"):$PYTHONPATH
  '';

  buildInputs = [ autoconf automake libtool makeWrapper intltool python ];

  meta = {
    homepage = http://www.linuxrising.org;
    license = stdenv.lib.licenses.lgpl21;
    description = "A video transcoder using GStreamer";
  };
}
