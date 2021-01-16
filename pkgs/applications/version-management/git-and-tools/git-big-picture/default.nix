{ fetchFromGitHub, python3Packages, lib, git, graphviz }:

python3Packages.buildPythonApplication rec {
  pname = "git-big-picture";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "git-big-picture";
    repo = pname;
    rev = "v${version}";
    sha256 = "14yf71iwgk78nw8w0bpijsnnl4vg3bvxsw3vvypxmbrc1nh0bdha";
  };

  buildInputs = [ git graphviz ];

  # NOTE: Tests are disabled due to unpackaged test dependency "Scruf".
  #       When bumping to 1.1.0, please re-enable and use:
  #checkInputs = [ cram git pytest ];
  #checkPhase = "pytest test.py";
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH ":" ${ lib.makeBinPath buildInputs  }
    '';

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = "https://github.com/git-big-picture/git-big-picture";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nthorne ];
  };
}
