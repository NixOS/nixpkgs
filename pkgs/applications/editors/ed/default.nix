{ stdenv, fetchurl
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "ed-${version}";
  version = "1.14.1";

  src = fetchurl {
    # gnu only provides *.lz tarball, which is unfriendly for stdenv bootstrapping
    #url = "mirror://gnu/ed/${name}.tar.gz";
    # When updating, please make sure the sources pulled match those upstream by
    # Unpacking both tarballs and running `find . -type f -exec sha256sum \{\} \; | sha256sum`
    # in the resulting directory
    urls = let file_sha512 = "84396fe4e4f0bf0b591037277ff8679a08b2883207628aaa387644ad83ca5fbdaa74a581f33310e28222d2fea32a0b8ba37e579597cc7d6145df6eb956ea75db";
      in [
        ("http://pkgs.fedoraproject.org/repo/extras/ed"
          + "/${name}.tar.bz2/sha512/${file_sha512}/${name}.tar.bz2")
        "http://fossies.org/linux/privat/${name}.tar.bz2"
      ];
    sha256 = "1pk6qa4sr7qc6vgm34hjx44hsh8x2bwaxhdi78jhsacnn4zwi7bw";
  };

  /* FIXME: Tests currently fail on Darwin:

       building test scripts for ed-1.5...
       testing ed-1.5...
       *** Output e1.o of script e1.ed is incorrect ***
       *** Output r3.o of script r3.ed is incorrect ***
       make: *** [check] Error 127

    */
  doCheck = !(hostPlatform.isDarwin || hostPlatform != buildPlatform);

  # TODO(@Ericson2314): Use placeholder to make this a configure flag once Nix
  # 1.12 is released.
  preConfigure = ''
    export DESTDIR=$out
  '';

  configureFlags = [
    "--exec-prefix=${stdenv.cc.prefix}"
    "CC=${stdenv.cc.prefix}cc"
  ];

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
}
