{ stdenv, fetchurl, lzip
}:

stdenv.mkDerivation (rec {
  name = "ed-${version}";
  version = "1.15";

  src = fetchurl {
    url = "mirror://gnu/ed/${name}.tar.lz";
    sha256 = "0x6ivy5k0d7dy5z9g8q8nipr89m4qbk2ink2898qq43smp08ji5d";
  };

  nativeBuildInputs = [ lzip ];

  doCheck = true; # not cross;

  meta = {
    description = "An implementation of the standard Unix editor";

    longDescription = ''
      GNU ed is a line-oriented text editor.  It is used to create,
      display, modify and otherwise manipulate text files, both
      interactively and via shell scripts.  A restricted version of ed,
      red, can only edit files in the current directory and cannot
      execute shell commands.  Ed is the "standard" text editor in the
      sense that it is the original editor for Unix, and thus widely
      available.  For most purposes, however, it is superseded by
      full-screen editors such as GNU Emacs or GNU Moe.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/ed/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  # This may be moved above during a stdenv rebuild.
  preConfigure = ''
    configureFlagsArray+=("CC=$CC")
  '';
})
