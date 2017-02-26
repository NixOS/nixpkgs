{ stdenv, fetchgit, pythonPackages, cdparanoia, cdrdao
, gst-python, gst-plugins-base, gst-plugins-good
, utillinux, makeWrapper, substituteAll, autoreconfHook }:

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
    pygobject2 gst-python musicbrainzngs
    pycdio pyxdg setuptools
    CDDB
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    python cdparanoia cdrdao utillinux makeWrapper
    gst-plugins-base gst-plugins-good
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
