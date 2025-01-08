{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation rec {
  pname = "ministat";
  version = "20150715-1";

  src = fetchgit {
    url = "https://git.decadent.org.uk/git/ministat.git";
    tag = "debian/${version}";
    sha256 = "1p4g0yqgsy4hiqhr8gqp8d38zxzrss5qz70s0bw3i2pg4w668k6f";
  };

  postPatch = ''
    patch -p1 < debian/patches/fix-ctype-usage.patch
    patch -p1 < debian/patches/not-bsd
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp ministat $out/bin
    cp ministat.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "Simple tool for statistical comparison of data sets";
    homepage = "https://git.decadent.org.uk/gitweb/?p=ministat.git";
    license = licenses.beerware;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.all;
    mainProgram = "ministat";
  };
}
