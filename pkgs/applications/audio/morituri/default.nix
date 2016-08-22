{ stdenv, fetchgit,  pythonPackages, cdparanoia, cdrdao
, gst_python, gst_plugins_base, gst_plugins_good
, utillinux, substituteAll, autoreconfHook , wrapGAppsHook }:

let
  inherit (pythonPackages) python;
in stdenv.mkDerivation rec {
  name = "morituri-${version}";
  version = "0.2.3.20151109";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/thomasvs/morituri.git";
    fetchSubmodules = true;
    rev = "135b2f7bf27721177e3aeb1d26403f1b29116599";
    sha256 = "1sl5y5j3gdbynf2v0gf9dwd2hzawj8lm8ywadid7qm34yn8lx12k";
  };

  pythonPath = with pythonPackages; [
    pygobject gst_python musicbrainzngs
    pycdio pyxdg setuptools
    CDDB
  ];

  nativeBuildInputs = [ autoreconfHook wrapGAppsHook ];
  buildInputs = [
    python cdparanoia cdrdao utillinux
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

  wrapPrefixVariables = "PYTHONPATH";

  meta = with stdenv.lib; {
    homepage = http://thomas.apestaart.org/morituri/trac/;
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ rycee jgeerds ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
