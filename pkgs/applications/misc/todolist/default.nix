{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "todolist-${version}";
  version = "0.8";

  goPackagePath = "github.com/gammons/todolist";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "todolist";
    rev = "${version}";
    sha256 = "0agv9a44q81qr960b7m1jxk0pb8ahk6lvmzmijvw4v6mbip2720z";
  };

  meta = with stdenv.lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "http://todolist.site";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
