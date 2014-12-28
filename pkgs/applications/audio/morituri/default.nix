{ stdenv, fetchurl, python, pythonPackages, cdparanoia, cdrdao
, pygobject, gst_python, gst_plugins_base, gst_plugins_good
, setuptools, utillinux, makeWrapper, substituteAll }:

stdenv.mkDerivation rec {
  name = "morituri-${version}";
  version = "0.2.3";
  namePrefix = "";

  src = fetchurl {
    url = "http://thomas.apestaart.org/download/morituri/${name}.tar.bz2";
    sha256 = "1b30bs1y8azl04izsrl01gw9ys0lhzkn5afxi4p8qbiri2h4v210";
  };

  pythonPath = [
    pygobject gst_python pythonPackages.musicbrainzngs
    pythonPackages.pycdio pythonPackages.pyxdg setuptools
  ];

  buildInputs = [
    python cdparanoia cdrdao utillinux makeWrapper
    gst_plugins_base gst_plugins_good
  ] ++ pythonPath;

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cdrdao cdparanoia python utillinux;
    })
  ];

  # This package contains no binaries to patch or strip.
  dontPatchELF = true;
  dontStrip = true;

  postInstall = ''
    wrapProgram "$out/bin/rip" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://thomas.apestaart.org/morituri/trac/;
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = [ maintainers.rycee ];
    license = licenses.gpl3Plus;
  };
}
