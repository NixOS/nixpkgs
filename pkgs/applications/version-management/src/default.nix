{ stdenv, fetchurl, python, rcs, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "src-${version}";
  version = "1.22";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "0xvfg3aikr2jh09vjvxsha7day5br88chvirncr59ad40da1fils";
  };

  buildInputs = [ python rcs git makeWrapper ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/src \
      --suffix PATH ":" "${rcs}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Simple single-file revision control";
    longDescription = ''
      SRC, acronym of Simple Revision Control, is RCS/SCCS reloaded with a
      modern UI, designed to manage single-file solo projects kept more than one
      to a directory. Use it for FAQs, ~/bin directories, config files, and the
      like. Features integer sequential revision numbers, a command set that
      will seem familiar to Subversion/Git/hg users, and no binary blobs
      anywhere.
    '';
    homepage = http://www.catb.org/esr/src/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ calvertvl AndersonTorres ];
  };
}
