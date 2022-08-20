{ lib, stdenv, fetchurl, gtk2-x11 , pkg-config , python3 , gfortran , lesstif
, cfitsio , getopt , perl , groff , which, darwin, ncurses
}:

let
  python3Env = python3.withPackages(ps: with ps; [ numpy ]);
in

stdenv.mkDerivation rec {
  srcVersion = "nov21a";
  version = "20211101_a";
  pname = "gildas";

  src = fetchurl {
    # For each new release, the upstream developers of Gildas move the
    # source code of the previous release to a different directory
    urls = [ "http://www.iram.fr/~gildas/dist/gildas-src-${srcVersion}.tar.xz"
      "http://www.iram.fr/~gildas/dist/archive/gildas/gildas-src-${srcVersion}.tar.xz" ];
    sha256 = "0fb6iqwh4hm7v7sib7sx98vxdavn3d6q2gq6y6vxg2z29g31f8g2";
  };

  nativeBuildInputs = [ pkg-config groff perl getopt gfortran which ];

  buildInputs = [ gtk2-x11 lesstif cfitsio python3Env ncurses ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation ]);

  patches = [ ./wrapper.patch ./clang.patch ./aarch64.patch ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument";

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin (with darwin.apple_sdk.frameworks; "-F${CoreFoundation}/Library/Frameworks");

  configurePhase=''
    substituteInPlace admin/wrapper.sh --replace '%%OUT%%' $out
    substituteInPlace admin/wrapper.sh --replace '%%PYTHONHOME%%' ${python3Env}
    substituteInPlace utilities/main/gag-makedepend.pl --replace '/usr/bin/perl' ${perl}/bin/perl
    source admin/gildas-env.sh -c gfortran -o openmp
    echo "gag_doc:        $out/share/doc/" >> kernel/etc/gag.dico.lcl
  '';

  postInstall=''
    mkdir -p $out/bin
    cp -a ../gildas-exe-${srcVersion}/* $out
    mv $out/$GAG_EXEC_SYSTEM $out/libexec
    cp admin/wrapper.sh $out/bin/gildas-wrapper.sh
    chmod 755 $out/bin/gildas-wrapper.sh
    for i in $out/libexec/bin/* ; do
      ln -s $out/bin/gildas-wrapper.sh $out/bin/$(basename "$i")
    done
  '';

  meta = {
    broken = stdenv.isDarwin;
    description = "Radioastronomy data analysis software";
    longDescription = ''
      GILDAS is a collection of state-of-the-art software
      oriented toward (sub-)millimeter radioastronomical
      applications (either single-dish or interferometer).
      It is daily used to reduce all data acquired with the
      IRAM 30M telescope and Plateau de Bure Interferometer
      PDBI (except VLBI observations). GILDAS is easily
      extensible. GILDAS is written in Fortran-90, with a
      few parts in C/C++ (mainly keyboard interaction,
      plotting, widgets).'';
    homepage = "http://www.iram.fr/IRAMFR/GILDAS/gildas.html";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.bzizou lib.maintainers.smaret ];
    platforms = lib.platforms.all;
  };

}
