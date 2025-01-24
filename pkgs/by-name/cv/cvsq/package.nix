{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cvs,
  perl,
  nettools,
  findutils,
  rsync,
  coreutils,
  diffutils,
}:

stdenv.mkDerivation rec {
  pname = "cvsq";
  version = "1.11";

  src = fetchurl {
    url = "http://www.linta.de/~aehlig/cvsq/cvsq-${version}.tgz";
    sha256 = "0491k4skk3jyyd6plp2kcihmxxav9rsch7vd1yi697m2fqckp5ws";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cvs
    perl
    nettools
    findutils
    rsync
    coreutils
    diffutils
  ];

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    substituteInPlace $out/bin/cvsq --replace "/bin/sh" "${stdenv.shell}"
    substituteInPlace $out/bin/lcvs --replace "/bin/sh" "${stdenv.shell}"
    wrapProgram $out/bin/cvsq --prefix PATH : ${
      lib.makeBinPath [
        cvs
        nettools
        findutils
        rsync
        coreutils
        diffutils
      ]
    }
    wrapProgram $out/bin/cvsq-branch --prefix PATH : ${
      lib.makeBinPath [
        cvs
        nettools
        findutils
        rsync
        coreutils
        diffutils
      ]
    }
    wrapProgram $out/bin/cvsq-merge --prefix PATH : ${
      lib.makeBinPath [
        cvs
        nettools
        findutils
        rsync
        coreutils
        diffutils
      ]
    }
    wrapProgram $out/bin/cvsq-switch --prefix PATH : ${
      lib.makeBinPath [
        cvs
        nettools
        findutils
        rsync
        coreutils
        diffutils
      ]
    }
    wrapProgram $out/bin/lcvs --prefix PATH : ${
      lib.makeBinPath [
        cvs
        nettools
        findutils
        rsync
        coreutils
        diffutils
      ]
    }
  '';

  meta = {
    description = "Collection of tools to work locally with CVS";
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
    homepage = "https://www.linta.de/~aehlig/cvsq/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ clkamp ];
    platforms = lib.platforms.all;
  };
}
