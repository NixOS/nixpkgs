{ fetchgit
, stdenv
, perl
}:
stdenv.mkDerivation rec {
  name = "git2cl";

  src = fetchgit {
    url = git://git.sv.gnu.org/git2cl.git;
    rev = "8373c9f74993e218a08819cbcdbab3f3564bbeba";
    sha256 = "b0d39379640c8a12821442431e2121f7908ce1cc88ec8ec6bede218ea8c21f2f";
  };

  buildCommand = ''
    ensureDir $out/bin
    cp ${src}/git2cl $out/bin
    sed -i 's|/usr/bin/perl|${perl}/bin/perl|' $out/bin/git2cl
  '';
}
