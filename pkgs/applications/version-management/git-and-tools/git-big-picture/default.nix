{ fetchFromGitHub, python2Packages, stdenv, git, graphviz }:

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
      --prefix PATH ":" ${ stdenv.lib.makeBinPath buildInputs  }
    '';

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = https://github.com/esc/git-big-picture;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nthorne ];
  };
}
