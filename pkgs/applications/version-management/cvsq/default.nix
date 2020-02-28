{ stdenv
, fetchurl
, makeWrapper
, cvs
, perl
, nettools
, findutils
, rsync
, coreutils
, diffutils
} :

stdenv.mkDerivation rec {
  pname = "cvsq";
  version = "1.10";

  src = fetchurl {
    url = "http://www.linta.de/~aehlig/cvsq/cvsq-${version}.tgz";
    sha256 = "1a2e5666d4d23f1eb673a505caeb771ac62a86ed69c9ab89c4e2696c2ccd0621";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cvs perl nettools findutils rsync coreutils diffutils ];


  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    substituteInPlace $out/bin/cvsq --replace "/bin/sh" "${stdenv.shell}"
    substituteInPlace $out/bin/lcvs --replace "/bin/sh" "${stdenv.shell}"
    wrapProgram $out/bin/cvsq --prefix PATH : ${stdenv.lib.makeBinPath
      [ cvs nettools findutils rsync coreutils diffutils ]}
    wrapProgram $out/bin/cvsq-branch --prefix PATH : ${stdenv.lib.makeBinPath
      [ cvs nettools findutils rsync coreutils diffutils ]}
    wrapProgram $out/bin/cvsq-merge --prefix PATH : ${stdenv.lib.makeBinPath
      [ cvs nettools findutils rsync coreutils diffutils ]}
    wrapProgram $out/bin/cvsq-switch --prefix PATH : ${stdenv.lib.makeBinPath
      [ cvs nettools findutils rsync coreutils diffutils ]}
    wrapProgram $out/bin/lcvs --prefix PATH : ${stdenv.lib.makeBinPath
      [ cvs nettools findutils rsync coreutils diffutils ]}
  '';

  meta = {
    description = ''A collection of tools to work locally with CVS'';
    longDescription = ''
      cvsq is a collection of tools to work locally with CVS.

      cvsq queues commits and other cvs commands in a queue to be executed later,
      when the machine is online again. In case of a commit (the default action)
      an actual copy of the working directory is made, so that you can continue
      editing without affecting the scheduled commit. You can even schedule
      several successive commits to the same file and they will be correctly
      committed as successive commits at the time of upload. This is different
      from an earlier script also named cvsq that you might have seen elsewhere.

      lcvs uses rsync to maintain a local copy of a cvs repository. It also
      gives a convenient interface to call cvs in such a way that it believes the
      current working directory refers to the local copy rather than to the actual
      repository. This is useful for commands like log, diff, etc; however it cannot
      be used for commits (that's what cvsq is for).
    '';
    homepage = https://www.linta.de/~aehlig/cvsq/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ clkamp ];
    platforms = stdenv.lib.platforms.all;
  };
}
