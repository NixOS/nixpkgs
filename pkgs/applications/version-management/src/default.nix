{ lib
, stdenv
, fetchurl
, python
, rcs
, git
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "src";
  version = "1.29";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-Tc+qBhLtC9u23BrqVniAprAV8YhXELvbMn+XxN5BQkE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    python
    rcs
    git
  ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/src \
      --suffix PATH ":" "${rcs}/bin"
  '';

  meta = with lib; {
    homepage = "http://www.catb.org/esr/src/";
    description = "Simple single-file revision control";
    longDescription = ''
      SRC, acronym of Simple Revision Control, is RCS/SCCS reloaded with a
      modern UI, designed to manage single-file solo projects kept more than one
      to a directory. Use it for FAQs, ~/bin directories, config files, and the
      like. Features integer sequential revision numbers, a command set that
      will seem familiar to Subversion/Git/hg users, and no binary blobs
      anywhere.
    '';
    changelog = "https://gitlab.com/esr/src/raw/${version}/NEWS";
    license = licenses.bsd2;
    maintainers = with maintainers; [ calvertvl AndersonTorres ];
    inherit (python.meta) platforms;
  };
}
