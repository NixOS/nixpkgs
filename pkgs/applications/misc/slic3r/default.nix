{ stdenv, fetchgit, perl, perlPackages, makeWrapper }:

let
  perlInputs = with perlPackages; [
    BoostGeometryUtils
    ClassXSAccessor
    EncodeLocale
    IOStringy
    MathClipper
    MathConvexHullMonotoneChain
    MathGeometryVoronoi
    MathPlanePath
    Moo
    Wx
    XMLSAX
  ];
in
stdenv.mkDerivation {
  name = "slic3r-0.9.10-dev";

  src = fetchgit {
    url = "git://github.com/alexrj/Slic3r";
    rev = "b3f1795cb4ad82fbf2168dd8faf6c00bd09d414e";
    sha256 = "b7cdc4210657831cf199d16b90d8696ccbcfb50d874bf051c9f2caeceee6066a";
  };

  buildInputs = [
    perl
    makeWrapper
  ] ++ perlInputs;

  buildPhase = ''
    ${perl}/bin/perl Build.PL
  '';

  installPhase = ''
    mkdir -vp $out/share/slic3r/
    cp -r * $out/share/slic3r/
    wrapProgram $out/share/slic3r/slic3r.pl --prefix PERL5LIB : $PERL5LIB
    mkdir -vp $out/bin
    ln -s $out/share/slic3r/slic3r.pl $out/bin/slic3r.pl
  '';

  meta = {
    homepage = "http://slic3r.org";
    description = "G-code generator for 3D printers";
    license = "AGPLv3";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
