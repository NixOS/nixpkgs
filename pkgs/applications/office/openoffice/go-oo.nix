{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
, autoconf, openldap, postgresql, bash
, langs ? [ "en-US" "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  downloadRoot = "http://download.services.openoffice.org/files/stable/";
  fileUrl = part: "${downloadRoot}3.2.0/OOo_3.2.0_src_${part}.tar.bz2";
  tag = "OOO320_m12";
in
stdenv.mkDerivation rec {
  name = "go-oo-3.2.0.10";
  # builder = ./builder.sh;

  downloadRoot = "http://download.services.openoffice.org/files/stable";

  src = fetchurl {
      url = "http://download.go-oo.org/OOO320/ooo-build-3.2.0.10.tar.gz";
      sha256 = "0g6n0m9pibn6cx12zslmknzy1p764nqj8vdf45l5flyls9aj3x21";
    };

  srcs_download = [
    (fetchurl {
      url = fileUrl "binfilter";
      sha256 = "1jl3a3zyb03wzi297llr69qpnimdc99iv82yvgxy145hz21xbjra";
    })
    (fetchurl {
      url = fileUrl "core";
      sha256 = "0jl14rxmvhz86jlhhwqlbr9nfi9p271aknqxada9775qfm6bjjml";
    })
    (fetchurl {
      url = fileUrl "extensions";
      sha256 = "1l2xby47pflcqbv3m6ihjsv89ax96lvpl76wklwlcn8vzclbfqk8";
    })
    (fetchurl {
      url = fileUrl "system";
      sha256 = "0nihw4iyh9qc188dkyfjr3zvp6ym6i1spm16j0cyh5rgxcrn6ycp";
    })
    (fetchurl {
      url = fileUrl "l10n";
      sha256 = "1sp4b9r6qiczw875swk7p8r8bdxdyrwr841xn53xxxfglc4njba9";
    })
  ] ++ (import ./go-srcs.nix { inherit fetchurl; });

  # Multi-CPU: --with-num-cpus=4 
  # The '--with-tag=XXXX' string I took from their 'configure' script. I write it so it matches the
  # logic in the script for "upstream version for X.X.X". Look for that string in the script.
  # We need '--without-split' when downloading directly usptream openoffice src tarballs.
  configurePhase = ''
    sed -i -e '1s,/bin/bash,${bash}/bin/bash,' $(find bin -type f)
    sed -i -e '1s,/usr/bin/perl,${perl}/bin/perl,' download.in bin/ooinstall bin/generate-bash-completion
    echo "$distroFlags" > distro-configs/SUSE-11.1.conf.in

    ./configure --with-distro=SUSE-11.1 --with-system-libwpd --without-git --with-system-cairo \
      --with-lang="${langsSpaces}" --with-tag=${tag} --without-split
  '';

  buildPhase = ''
    for a in $srcs_download; do
      FILE=$(basename $a)
      # take out the hash
      cp -v $a src/$(echo $FILE | sed 's/[^-]*-//')
    done
    sed '/-x $WGET/d' -i download
    ./download
    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    # Take away a patch, that upstream already applied (3.2.0 specific)
    sed -i -e 's,^connectivity-build-fix-mac.diff,#,' patches/dev300/apply

    make build.prepare

    set -x
    pushd build/${tag}
    # Fix svtools: hardcoded jpeg path
    sed -i -e 's,^JPEG3RDLIB=.*,JPEG3RDLIB=${libjpeg}/lib/libjpeg.so,' solenv/inc/libs.mk
    # Fix sysui: wants to create a tar for root
    sed -i -e 's,--own.*root,,' sysui/desktop/slackware/makefile.mk
    # Fix libtextcat: wants to set rpath to /usr/local/lib
    sed -i -e 's,^CONFIGURE_FLAGS.*,& --prefix='$TMPDIR, libtextcat/makefile.mk
    # Fix hunspell: the checks fail due to /bin/bash missing, and I find this fix easier
    sed -i -e 's,make && make check,make,' hunspell/makefile.mk
    # Fix redland: wants to set rpath to /usr/local/lib
    sed -i -e 's,^CONFIGURE_FLAGS.*,& --prefix='$TMPDIR, redland/redland/makefile.mk \
      redland/raptor/makefile.mk redland/rasqal/makefile.mk
    popd

    set +x
    make
  '';

  installPhase = ''
    bin/ooinstall $out
    ensureDir $out/bin
    for a in $out/program/{sbase,scalc,sdraw,simpress,smath,soffice,swriter,soffice.bin}; do
      ln -s $a $out/bin
    done
  '';

  distroFlags = ''
    --with-vendor=NixPkgs
    --with-package-format=native
    --disable-epm
    --disable-fontooo
    --disable-gnome-vfs
    --disable-gnome-vfs
    --disable-mathmldtd
    --disable-mozilla
    --disable-odk
    --disable-pasf
    --disable-dbus
    --disable-kde
    --disable-kde4
    --disable-mono
    --disable-gstreamer
    --with-cairo
    --with-system-libs
    --with-system-python
    --with-system-boost
    --with-system-db
    --with-jdk-home=${jdk}
    --with-ant-home=${ant}
    --without-afms
    --without-dict
    --without-fonts
    --without-myspell-dicts
    --without-nas
    --without-ppds
    --without-system-agg
    --without-system-beanshell
    --without-system-hsqldb
    --without-system-xalan
    --without-system-xerces
    --without-system-xml-apis
    --without-system-xt
    --without-system-jars
    --without-system-hunspell
    --without-system-altlinuxhyph
    --without-system-lpsolve
    --without-system-graphite
    --without-system-mozilla
    --without-system-libwps
    --without-system-libwpg
  '';

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama openssl gperf GConf ORBit2

    ant autoconf openldap postgresql
  ];

  meta = {
    description = "Go-oo - Novell variant of OpenOffice.org";
    homepage = http://go-oo.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
