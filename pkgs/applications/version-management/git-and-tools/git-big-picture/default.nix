{ fetchgit, python2Packages, stdenv, git, graphviz }:

python2Packages.buildPythonApplication rec {
    pname = "git-big-picture";
    version = "0.9.0";

    name = "${pname}-${version}";

    src = fetchgit {
      url = "https://github.com/esc/${pname}.git";
      rev = "fbe3b9504e255da859067fd58e90d849d63e5381";
      sha256 = "1h283gzs4nx8lrarmr454zza52cilmnbdrqn1n33v3cn1rayl3c9";
    };

  propagatedBuildInputs = [ git graphviz ];

  meta = {
    description = "Tool for visualization of Git repositories.";
    homepage = https://github.com/esc/git-big-picture;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
