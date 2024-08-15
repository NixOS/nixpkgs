{ lib, stdenv, autoreconfHook, fetchFromGitLab, fetchpatch, flac, libao, libvorbis, ncurses
, opusfile, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "squishyball";
  version = "unstable-2020-11-23";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org";
    owner = "xiph";
    repo = "squishyball";
    rev = "27590fe6bac545e2dd3eacf048edbd969682263a";
    sha256 = "07zs8wx1ahf3q505fk9b6cgzlkhnayfsscch46yy9s1wgxgphj7s";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ flac libao libvorbis ncurses opusfile ];

  patches = [
    ./gnu-screen.patch

    # Patch pending upstream inclusion for ncurses-6.3 support:
    #  https://gitlab.xiph.org/xiph/squishyball/-/issues/1
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://gitlab.xiph.org/xiph/squishyball/uploads/5609ceaf85ebb6dc297c0efe61b9a1b7/0001-mincurses.c-use-ncurses-API-to-enter-raw-mode-ncurse.patch";
      sha256 = "06llp7cd77f4vvhz8qdld551dnlpjxf98j7rmp3i1x1kng4f0iy3";
    })
  ];

  postInstall = ''
    # Why doesn’t this happen automagically?
    mkdir -p $out/share/man/man1
    cp squishyball.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "Tool to perform sample comparison testing on the command line";
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
    homepage = "https://gitlab.xiph.org/xiph/squishyball";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michalrus ];
    platforms = platforms.linux;
    mainProgram = "squishyball";
  };
}
