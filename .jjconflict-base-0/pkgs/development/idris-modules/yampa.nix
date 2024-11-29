{ build-idris-package
, fetchFromGitHub
, bifunctors
, lib
}:
build-idris-package  {
  pname = "yampa";
  version = "2016-07-05";

  ipkgName = "idris-yampa";
  idrisDeps = [ bifunctors ];

  src = fetchFromGitHub {
    owner = "BartAdv";
    repo = "idris-yampa";
    rev = "2120dffb3ea0de906ba2b40080956c900457cf33";
    sha256 = "0zp495zpbvsagdzrmg9iig652zbm34qc0gdr81x0viblwqxhicx6";
  };

  meta = {
    description = "Idris implementation of Yampa FRP library as described in Reactive Programming through Dependent Types";
    homepage = "https://github.com/BartAdv/idris-yampa";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
