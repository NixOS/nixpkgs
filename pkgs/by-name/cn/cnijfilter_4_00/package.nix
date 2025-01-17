{
  stdenv,
  lib,
  fetchzip,
  autoconf,
  automake,
  libtool,
  cups,
  popt,
  libtiff,
  libpng,
  ghostscript,
  glib,
  libusb1,
  libxml2,
}:

/*
  this derivation is basically just a transcription of the rpm .spec
  file included in the tarball
*/

let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "32"
    else
      throw "Unsupported system ${stdenv.hostPlatform.system}";

in
stdenv.mkDerivation {
  pname = "cnijfilter";

  /*
    important note about versions: cnijfilter packages seem to use
    versions in a non-standard way.  the version indicates which
    printers are supported in the package.  so this package should
    not be "upgraded" in the usual way.

    instead, if you want to include another version supporting your
    printer, you should try to abstract out the common things (which
    should be pretty much everything except the version and the 'pr'
    and 'pr_id' values to loop over).
  */
  version = "4.00";

  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/5/0100005515/01/cnijfilter-source-4.00-1.tar.gz";
    sha256 = "1f6vpx1z3qa88590i5m0s49j9n90vpk81xmw6pvj0nfd3qbvzkya";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [
    libtool
    cups
    popt
    libtiff
    libpng
    ghostscript
    glib
    libusb1
    libxml2
  ];

  # patches from https://github.com/tokiclover/bar-overlay/tree/master/net-print/cnijfilter
  patches = [
    ./patches/cnijfilter-3.80-1-cups-1.6.patch
    ./patches/cnijfilter-3.80-6-cups-1.6.patch
    ./patches/cnijfilter-4.00-4-ppd.patch
    ./patches/cnijfilter-4.00-5-abi_x86_32.patch
    ./patches/cnijfilter-4.00-6-headers.patch
    ./patches/cnijfilter-4.00-7-sysctl.patch
  ];

  postPatch = ''
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backend/src/Makefile.am;
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backendnet/backend/Makefile.am;
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" cnijbe/src/Makefile.am;
    sed -i "s|/usr|$out|" backend/src/cnij_backend_common.c;
    sed -i "s|/usr/bin|${ghostscript}/bin|" pstocanonij/filter/pstocanonij.c;
  '';

  configurePhase = ''
    cd libs
    ./autogen.sh --prefix=$out

    cd ../bscc2sts
    ./autogen.sh

    cd ../cnijnpr
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib

    cd ../cngpij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../cngpijmnt
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../pstocanonij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../backend
    ./autogen.sh --prefix=$out

    cd ../backendnet
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib --enable-progpath=$out/bin

    cd ../cmdtocanonij
    ./autogen.sh --prefix=$out --datadir=$out/share

    cd ../cnijbe
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../lgmon2
    substituteInPlace src/Makefile.am \
        --replace /usr/include/libusb-1.0 \
                  ${libusb1.dev}/include/libusb-1.0
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib --enable-progpath=$out/bin

    cd ..;

    sed -e "s,cnijlgmon2_LDADD =,cnijlgmon2_LDADD = -L../../com/libs_bin${arch}," \
    -i lgmon2/src/Makefile.am || die
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model;
  '';

  postInstall = ''
    set -o xtrace
    for pr in mg2400 mg2500 mg3500 mg5500 mg6400 mg6500 mg7100 p200; do
      cd ppd;
      ./autogen.sh --prefix=$out --program-suffix=$pr
      make clean;
      make;
      make install;

      cd ../cnijfilter;
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-libpath=/var/lib/cups/path/lib/bjlib --enable-binpath=$out/bin;
      make clean;
      make;
      make install;

      cd ..;
    done;

    mkdir -p $out/lib/bjlib;
    for pr_id in 423 424 425 426 427 428 429 430; do
      install -c -m 755 $pr_id/database/* $out/lib/bjlib;
      install -c -s -m 755 $pr_id/libs_bin${arch}/*.so.* $out/lib;
    done;

    pushd $out/lib;
    for so_file in *.so.*; do
      ln -s $so_file ''${so_file/.so.*/}.so;
      patchelf --set-rpath $out/lib $so_file;
    done;
    popd;
  '';

  /*
    the tarball includes some pre-built shared libraries.  we run
    'patchelf --set-rpath' on them just a few lines above, so that
    they can find each other.  but that's not quite enough.  some of
    those libraries load each other in non-standard ways -- they
    don't list each other in the DT_NEEDED section.  so, if the
    standard 'patchelf --shrink-rpath' (from
    pkgs/development/tools/misc/patchelf/setup-hook.sh) is run on
    them, it undoes the --set-rpath.  this prevents that.
  */
  dontPatchELF = true;

  meta = with lib; {
    description = "Canon InkJet printer drivers for the MG2400 MG2500 MG3500 MG5500 MG6400 MG6500 MG7100 and P200 series";
    homepage = "https://www.canon-europe.com/support/consumer_products/products/fax__multifunctionals/inkjet/pixma_mg_series/pixma_mg5550.aspx?type=drivers&driverdetailid=tcm:13-1094072";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chpatrick ];
  };
}
