{ stdenv, git, python3 }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.25.0";

  # do NOT fetch the git repo directly:
  # the 'master' branch is missing documentation files,
  # and the Makefile borks attempting to use git to check them out
  src = fetchTarball {
    url = "https://github.com/newren/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "10wx1px9hkxxn7li4j97a069sbcyc4za0kzz4v8ij8y0hdxgfhk5";
  };

  propagatedBuildInputs = [ git python3 ];

  # attempts to call python's coverage framework; needs perl, fails with missing modules ... messy
  doCheck = false;

  # Makefile makes a mess of this, assumes the Python version etc
  # ... also, the python setup.py is broken: ignore both
  installPhase = ''
    install -Dv ./Documentation/man1/git-filter-repo.1 "$out"/share/man/man1/git-filter-repo.1
    install -Dv ./Documentation/html/git-filter-repo.html "$out"/share/doc/git-doc/git-filter-repo.html
    install -Dv ./git-filter-repo "$out"/bin/git-filter-repo
  '';

  meta = with stdenv.lib; {
    description = "Quickly rewrite git repository history (filter-branch replacement)";
    homepage = https://github.com/newren/git-filter-repo;
    license = licenses.mit;
    maintainers = [ "https://github.com/newren" ];
    platforms = platforms.all;
  };
}
