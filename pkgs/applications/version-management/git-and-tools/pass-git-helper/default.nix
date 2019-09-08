{ stdenv, buildPythonApplication, fetchFromGitHub, pyxdg }:

buildPythonApplication rec {
  pname   = "pass-git-helper";
  version = "0.4";

  src = fetchFromGitHub {
    owner  = "languitar";
    repo   = "pass-git-helper";
    rev    = version;
    sha256 = "1zccbmq5l6asl9qm1f90vg9467y3spmv3ayrw07qizrj43yfd9ap";
  };

  propagatedBuildInputs = [ pyxdg ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "A git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
  };
}
