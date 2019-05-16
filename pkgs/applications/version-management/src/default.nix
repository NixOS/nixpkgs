{ stdenv, fetchurl, python, rcs, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "src-${version}";
  version = "1.25";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "0qd10w8fwbrgaj8sx49q6cfhqq3ylhwn7nl9v6kxi1yjlw2p098p";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python rcs git ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];

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
    homepage = "http://www.catb.org/esr/src/";
    changelog = "https://gitlab.com/esr/src/raw/${version}/NEWS";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ calvertvl AndersonTorres ];
  };
}
