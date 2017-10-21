{ stdenv, autoreconfHook, fetchsvn, flac, libao, libvorbis, ncurses
, opusfile, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "squishyball-${rev}";
  rev = "19580";

  src = fetchsvn {
    url = "https://svn.xiph.org/trunk/squishyball";
    rev = rev;
    sha256 = "013vq52q9z6kpg9iyc2jnb3m2gihcjblvwpg4yj4wy1q2c05pzqp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ flac libao libvorbis ncurses opusfile ];

  patches = [ ./gnu-screen.patch ];

  postInstall = ''
    # Why doesn’t this happen automagically?
    mkdir -p $out/share/man/man1
    cp squishyball.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A tool to perform sample comparison testing on the command line";
    longDescription = ''
       squishyball is a simple command-line utility for performing
       double-blind A/B, A/B/X or X/X/Y testing on the command line.
       The user specifies two input files to be compared and uses the
       keyboard during playback to flip between the randomized samples
       to perform on-the-fly compar‐ isons.  After a predetermined
       number of trials, squishyball prints the trial results to
       stdout and exits.  Results (stdout) may be redirected to a file
       without affecting interactive use of the terminal.

       squishyball can also be used to perform casual, non-randomized
       comparisons of groups of up to ten samples; this is the default
       mode of operation.
    '';
    homepage = https://svn.xiph.org/trunk/squishyball;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michalrus ];
    platforms = platforms.linux;
  };
}
