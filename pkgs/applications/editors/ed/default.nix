{ stdenv, fetchurl, lzip
}:

stdenv.mkDerivation (rec {
  name = "ed-${version}";
  version = "1.14.2";

  src = fetchurl {
    url = "mirror://gnu/ed/${name}.tar.lz";
    sha256 = "1nqhk3n1s1p77g2bjnj55acicsrlyb2yasqxqwpx0w0djfx64ygm";
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

    homepage = http://www.gnu.org/software/ed/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  # This may be moved above during a stdenv rebuild.
  preConfigure = ''
    configureFlagsArray+=("CC=$CC")
  '';
})
