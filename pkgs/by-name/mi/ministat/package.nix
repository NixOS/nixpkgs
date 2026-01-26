{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ministat";
  version = "20150715-1";

  src = fetchgit {
    url = "https://git.decadent.org.uk/git/ministat.git";
    tag = "debian/${finalAttrs.version}";
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

  meta = {
    description = "Simple tool for statistical comparison of data sets";
    homepage = "https://git.decadent.org.uk/gitweb/?p=ministat.git";
    license = lib.licenses.beerware;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.all;
    mainProgram = "ministat";
  };
})
