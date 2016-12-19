{ callPackage, fetchgit, lua } :
let
  src = fetchgit {
    url = "https://github.com/grwlf/torch-distro";
    rev = "f972c4253b14b95b53aefe7b24efa496223e73f2";
    sha256 = "1lhjhivhyypaic33vj1nsghshsajf7vi6gwsclaf3nqdl27d1h1s";
  };

in
  callPackage (import ./torch-distro.nix) { inherit lua src; }
