{ stdenv, fetchurl, unzip }:

let

  # Helper for the common case where we have separate feature and
  # plugin JARs.
  buildEclipsePlugin = { name, version, javaName, srcFeature, srcPlugin, meta }:
    stdenv.mkDerivation {
      name = "eclipse-" + name;
      inherit meta;

      srcs = [ srcFeature srcPlugin ];

      buildInputs = [ unzip ];
      phases = [ "installPhase" ];

      installPhase = ''
        dropinDir="$out/eclipse/dropins/${name}"
        mkdir -p $dropinDir/features/${javaName}_${version}
        unzip ${srcFeature} -d $dropinDir/features/${javaName}_${version}

        mkdir -p $dropinDir/plugins
        cp -v ${srcPlugin} $dropinDir/plugins/${javaName}_${version}.jar
      '';

    };

in {

  anyedittools = buildEclipsePlugin rec {
    name = "anyedit-${version}";
    version = "2.4.15.201504172030";
    javaName = "de.loskutov.anyedit.AnyEditTools";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/AnyEditTools_${version}.jar";
      sha256 = "19hbwgqn02ghflbcp5cw3qy203mym5kwgzq4xrn0xcl8ckl5s2pp";
    };

    srcPlugin = fetchurl {
      url = "http://dl.bintray.com/iloveeclipse/plugins/${javaName}_${version}.jar";
      sha256 = "1i3ghf2mhdfhify30hlyxqmyqcp40pkd5zhsiyg6finn4w81sxv2";
    };

    meta = with stdenv.lib; {
      homepage = http://andrei.gmxhome.de/anyedit/;
      description = "Adds new tools to the context menu of text-based editors";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  emacsplus = buildEclipsePlugin rec {
    name = "emacsplus-${version}";
    version = "4.2.0";
    javaName = "com.mulgasoft.emacsplus";

    srcFeature = fetchurl {
      url = "http://www.mulgasoft.com/emacsplus/e4/update-site/features/${javaName}.feature_${version}.jar";
      sha256 = "0wja3cd7gq8w25797fxnafvcncjnmlv8qkl5iwqj7zja2f45vka8";
    };

    srcPlugin = fetchurl {
      url = "http://www.mulgasoft.com/emacsplus/e4/update-site/plugins/${javaName}_${version}.jar";
      sha256 = "08yw45nr90mlpdzim74vsvdaxj41sgpxcrqk5ia6l2dzvrqlsjs1";
    };

    meta = with stdenv.lib; {
      homepage = http://www.mulgasoft.com/emacsplus/;
      description = "Provides a more Emacs-like experience in the Eclipse text editors";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  findbugs = buildEclipsePlugin rec {
    name = "findbugs-${version}";
    version = "3.0.1.20150306-5afe4d1";
    javaName = "edu.umd.cs.findbugs.plugin.eclipse";

    srcFeature = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/features/${javaName}_${version}.jar";
      sha256 = "1m9fav2xlb9wrx2d00lpnh2sy0w5yzawynxm6xhhbfdzd0vpfr9v";
    };

    srcPlugin = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/plugins/${javaName}_${version}.jar";
      sha256 = "10p3mrbp9wi6jhlmmc23qv7frh605a23pqsc7w96569bsfb5wa8q";
    };

    meta = with stdenv.lib; {
      homepage = http://findbugs.sourceforge.net/;
      description = "Plugin that uses static analysis to look for bugs in Java code";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

}
