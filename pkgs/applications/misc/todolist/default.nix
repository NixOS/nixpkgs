{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "todolist-${version}";
  version = "v0.8.1";

  goPackagePath = "github.com/gammons/todolist";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "todolist";
    rev = "${version}";
    sha256 = "0dazfymby5xm4482p9cyj23djmkz5q7g79cqm2d85mczvz7vks8p";
  };

  meta = with stdenv.lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "http://todolist.site";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
