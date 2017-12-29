{ fetchFromGitHub, python2Packages, stdenv, git, graphviz }:

python2Packages.buildPythonApplication rec {
  pname = "git-big-picture";
  version = "0.9.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "esc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h283gzs4nx8lrarmr454zza52cilmnbdrqn1n33v3cn1rayl3c9";
  };

  buildInputs = [ git graphviz ];

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath buildInputs  }
    '';

  meta = {
    description = "Tool for visualization of Git repositories.";
    homepage = https://github.com/esc/git-big-picture;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nthorne ];
  };
}
