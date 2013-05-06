{ stdenv, buildPerlPackage, fetchgit, perl, perlPackages, makeWrapper }:

let
  perlInputs = with perlPackages; [
    BoostGeometryUtils
    ClassXSAccessor
    EncodeLocale
    IOStringy
    MathClipper
    MathConvexHullMonotoneChain
    MathGeometryVoronoi
    MathGeometryVoronoi
    MathPlanePath
    Moo
    Wx
    XMLSAX
  ];
in
stdenv.mkDerivation {
  name = "slic3r-0.9.9";

  src = fetchgit {
    url = "git://github.com/alexrj/Slic3r";
    rev = "0.9.9";
    sha256 = "ebef71283189df82ca0acc69a42ec7b3d54703e900f25366196b81df2d2fe718";
  };

  buildInputs = [
    perl
    makeWrapper
  ] ++ perlInputs;

  buildPhase = ''
    ${perl}/bin/perl Build.PL
  '';

  installPhase = ''
    mkdir -vp $out/bin
    cp -r * $out/
    wrapProgram $out/slic3r.pl --prefix PERL5LIB : $PERL5LIB
    ln -s $out/slic3r.pl $out/bin/slic3r.pl
  '';

  meta = {
    homepage = "http://www.linux-france.org/prj/imapsync/";
    description = "Mail folder synchronizer between IMAP servers";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
