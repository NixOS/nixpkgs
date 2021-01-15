{ fetchFromGitHub, python2Packages, lib, stdenv, git, graphviz }:

python2Packages.buildPythonApplication rec {
  pname = "git-big-picture";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "esc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b0zdq7d7k7f6p3wwc799347fraphbr20rxd1ysnc4xi1cj4wpmi";
  };

  buildInputs = [ git graphviz ];

  checkInputs = [ git ];

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH ":" ${ lib.makeBinPath buildInputs  }
    '';

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = "https://github.com/esc/git-big-picture";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nthorne ];
  };
}
