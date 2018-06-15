{ stdenv, fetchurl
, xproto, motif, libX11, libXt, libXpm, bison
, flex, automake, autoconf, libtool
}:

stdenv.mkDerivation rec {
  name = "alliance-${version}";
  version = "5.1.1";

  src = fetchurl {
    url = "http://www-asim.lip6.fr/pub/alliance/distribution/5.0/${name}.tar.bz2";
    sha256 = "046c9qwl1vbww0ljm4xyxf5jpz9nq62b2q0wdz9xjimgh4c207w1";
  };


  nativeBuildInputs = [ libtool automake autoconf flex ];
  buildInputs = [ xproto motif xproto libX11 libXt libXpm bison ];

  sourceRoot = "alliance/src/";

  configureFlags = [
    "--prefix=$(out)"
    "--disable-static"
  ];

  preConfigure = ''
    mkdir -p $out/etc

    #texlive for docs seems extreme
    mkdir -p $out/share/alliance
    mv ./documentation $out/share/alliance
    substituteInPlace autostuff \
      --replace "$newdirs documentation" "$newdirs" \
      --replace documentation Solaris

    substituteInPlace sea/src/DEF_grammar_lex.l \
      --replace "ifndef FLEX_BETA" "if (YY_FLEX_MAJOR_VERSION <= 2) && (YY_FLEX_MINOR_VERSION < 6)"
    ./autostuff
  '';

  allianceInstaller = ''
    #!${stdenv.shell}
    cp -v -r -n --no-preserve=mode  $out/etc/* /etc/ > /etc/alliance-install.log
  '';

  allianceUnInstaller = ''
    #!${stdenv.shell}
    awk '{print \$3}' /etc/alliance-install.log | xargs rm
    awk '{print \$3}' /etc/alliance-install.log | xargs rmdir
    rm /etc/alliance-install.log
  '';

  postInstall = ''
    sed -i "s|ALLIANCE_TOP|$out|" distrib/*.desktop
    mkdir -p $out/share/applications
    cp -p distrib/*.desktop $out/share/applications/
    mkdir -p $out/icons/hicolor/48x48/apps/
    cp -p distrib/*.png $out/icons/hicolor/48x48/apps/

    echo "${allianceInstaller}" > $out/bin/alliance-install
    chmod +x $out/bin/alliance-install

    echo "${allianceUnInstaller}" > $out/bin/alliance-uninstall
    chmod +x $out/bin/alliance-uninstall
  '';

  meta = with stdenv.lib; {
    description = "Complete set of free CAD tools and portable libraries for VLSI design";
    homepage = http://www-asim.lip6.fr/recherche/alliance/;
    license = with licenses; gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
    broken = true;
  };
}
