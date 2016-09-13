{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "cua-mode-2.10";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://tarballs.nixos.org/cua-mode-2.10.el;
    sha256 = "01877xjbq0v9wrpcbnhvppdn9wxliwkkjg3dr6k795mjgslwhr1b";
  };
}
