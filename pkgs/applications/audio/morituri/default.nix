{ stdenv, fetchgit, python, pythonPackages, cdparanoia, cdrdao
, pygobject, gst_python, gst_plugins_base, gst_plugins_good
, setuptools, utillinux, makeWrapper, substituteAll, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "morituri-${version}";
  version = "0.2.3.20151109";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/thomasvs/morituri.git";
    fetchSubmodules = true;
    rev = "135b2f7bf27721177e3aeb1d26403f1b29116599";
    sha256 = "1ccxq1spny6xgd7nqwn13n9nqa00ay0nhflg3vbdkvbirh8fgxwq";
  };

  pythonPath = [
    pygobject gst_python pythonPackages.musicbrainzngs
    pythonPackages.pycdio pythonPackages.pyxdg setuptools
    pythonPackages.CDDB
  ];

  nativeBuildInputs = [ autoreconfHook ];
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
    maintainers = with maintainers; [ rycee jgeerds ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
