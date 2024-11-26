{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  ncurses,
}:
stdenv.mkDerivation {
  pname = "visual-hexdiff";
  version = "0.0.53";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/h/hexdiff/hexdiff_0.0.53.orig.tar.gz";
    hash = "sha256-M1bmkW63pHlfl9zNWEq0EGN1rpVGo+BTUKM9ot4HWqo=";
  };

  patches = [
    # Some changes the debian/ubuntu developers made over the original source code
    # See https://changelogs.ubuntu.com/changelogs/pool/universe/h/hexdiff/hexdiff_0.0.53-0ubuntu4/changelog
    (fetchpatch {
      url = "mirror://ubuntu/pool/universe/h/hexdiff/hexdiff_0.0.53-0ubuntu4.diff.gz";
      sha256 = "sha256-X5ONNp9jeACxsulyowDQJ6REX6bty6L4in0/+rq8Wz4=";
      decode = "gunzip --stdout";
      name = "hexdiff_0.0.53-0ubuntu4.diff";
      stripLen = 1;
    })
  ];

  postPatch =
    ''
      # Fix compiler error that wants a string literal as format string for `wprintw`
      substituteInPlace sel_file.c \
        --replace-fail 'wprintw(win, txt_aide_fs[foo]);' 'wprintw(win, "%s", txt_aide_fs[foo]);'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Fix compiler error on Darwin: conflicting types for 'strdup'
      substituteInPlace sel_file.c \
        --replace-fail 'char *strdup(char *);' ' '
    '';

  buildInputs = [ ncurses ];

  preInstall = ''
    mkdir -p $out/bin/
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Visual hexadecimal difference editor";
    homepage = "http://tboudet.free.fr/hexdiff/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "hexdiff";
    platforms = platforms.unix;
  };
}
