{ python3Packages }:
let
  version = "1.2.4";
in {
  inherit version;
  frontend = python3Packages.fetchPypi {
    pname = "paperwork";
    inherit version;
    sha256 = "0kdbwdm3d7r7dna7gw5jj2lvalzzdyj4r6dvcadj3z3d0ybx4ich";
  };
  backend = python3Packages.fetchPypi {
    pname = "paperwork-backend";
    inherit version;
    sha256 = "1fy0349dqc7aqdg1igkk5j5vw0ybhks7ykxfqnndgf0zkrrlzmfg";
  };
}
