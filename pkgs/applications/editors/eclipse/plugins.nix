{ stdenv, fetchurl, fetchzip, unzip }:

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

  # Helper for the case where we have a ZIP file containing an Eclipse
  # update site.
  buildEclipseUpdateSite = { name, version, src, meta }:
    stdenv.mkDerivation {
      name = "eclipse-" + name;
      inherit meta src;

      buildInputs = [ unzip ];
      phases = [ "unpackPhase" "installPhase" ];

      installPhase = ''
        dropinDir="$out/eclipse/dropins/${name}"

        cd features
        for feature in *.jar; do
          feat=''${feature%.jar}
          mkdir -p $dropinDir/features/$feat
          unzip $feature -d $dropinDir/features/$feat
        done
        cd ..

        mkdir -p $dropinDir/plugins
        cp -v "plugins/"*.jar $dropinDir/plugins/
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

  checkstyle = buildEclipseUpdateSite rec {
    name = "checkstyle-${version}";
    version = "6.5.0.201504121610";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclipse-cs/Eclipse%20Checkstyle%20Plug-in/6.5.0/net.sf.eclipsecs-updatesite_6.5.0.201504121610-bin.zip";
      sha256 = "1zikpkss0c3l460ipvznp22kpak8w31n7k6yk41nc1w49zflvcf0";
    };

    meta = with stdenv.lib; {
      homepage = http://eclipse-cs.sourceforge.net/;
      description = "Checkstyle integration into the Eclipse IDE";
      license = licenses.lgpl21;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };

  };

  color-theme = buildEclipsePlugin rec {
    name = "color-theme-${version}";
    version = "1.0.0.201410260308";
    javaName = "com.github.eclipsecolortheme";

    srcFeature = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/features/${javaName}.feature_${version}.jar";
      sha256 = "128b9b1cib5ff0w1114ns5mrbrhj2kcm358l4dpnma1s8gklm8g2";
    };

    srcPlugin = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/plugins/${javaName}_${version}.jar";
      sha256 = "0wz61909bhqwzpqwll27ia0cn3anyp81haqx3rj1iq42cbl42h0y";
    };

    meta = with stdenv.lib; {
      homepage = http://eclipsecolorthemes.org/;
      description = "Plugin to switch color themes conveniently and without side effects";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  eclemma = buildEclipseUpdateSite rec {
    name = "eclemma-${version}";
    version = "2.3.2.201409141915";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclemma/01_EclEmma_Releases/2.3.2/eclemma-2.3.2.zip";
      sha256 = "0w1kwcjh45p7msv5vpc8i6dsqwrnfmjama6vavpnxlji56jd3c43";
    };

    meta = with stdenv.lib; {
      homepage = http://www.eclemma.org/;
      description = "EclEmma is a free Java code coverage tool for Eclipse";
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

  testng = buildEclipsePlugin rec {
    name = "testng-${version}";
    version = "6.9.5.201506120235";
    javaName = "org.testng.eclipse";

    srcFeature = fetchurl {
      url = "http://beust.com/eclipse/features/org.testng.eclipse_6.9.5.201506120235.jar";
      sha256 = "02imv0rw10pik55a7p00jin65shvhfpzgna02ky94yx7dlf9fyy9";
    };

    srcPlugin = fetchurl {
      url = "http://beust.com/eclipse/plugins/org.testng.eclipse_6.9.5.201506120235.jar";
      sha256 = "0ni1ky4p5l1qzph0np1qw9pcyhrvy6zmn9c8q1b5rm5xv1fcvji4";
    };

    meta = with stdenv.lib; {
      homepage = http://testng.org/;
      description = "Eclipse plugin for the TestNG testing framework";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

}
