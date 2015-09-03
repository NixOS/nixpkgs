{ stdenv, fetchurl, fetchzip, unzip }:

rec {

  # A primitive builder of Eclipse plugins. This function is intended
  # to be used when building more advanced builders.
  buildEclipsePluginBase =  { name
                            , buildInputs ? []
                            , passthru ? {}
                            , ... } @ attrs:
    stdenv.mkDerivation (attrs // {
      name = "eclipse-plugin-" + name;

      buildInputs = buildInputs ++ [ unzip ];

      passthru = {
        isEclipsePlugin = true;
      } // passthru;
    });

  # Helper for the common case where we have separate feature and
  # plugin JARs.
  buildEclipsePlugin = { name, srcFeature, srcPlugin, ... } @ attrs:
    buildEclipsePluginBase (attrs // {
      srcs = [ srcFeature srcPlugin ];

      phases = [ "installPhase" ];

      installPhase = ''
        dropinDir="$out/eclipse/dropins/${name}"

        mkdir -p $dropinDir/features
        unzip ${srcFeature} -d $dropinDir/features/

        mkdir -p $dropinDir/plugins
        cp -v ${srcPlugin} $dropinDir/plugins/${name}.jar
      '';

    });

  # Helper for the case where the build directory has the layout of an
  # Eclipse update site, that is, it contains the directories
  # `features` and `plugins`. All features and plugins inside these
  # directories will be installed.
  buildEclipseUpdateSite = { name, ... } @ attrs:
    buildEclipsePluginBase (attrs // {
      phases = [ "unpackPhase" "installPhase" ];

      installPhase = ''
        dropinDir="$out/eclipse/dropins/${name}"

        # Install features.
        cd features
        for feature in *.jar; do
          featureName=''${feature%.jar}
          mkdir -p $dropinDir/features/$featureName
          unzip $feature -d $dropinDir/features/$featureName
        done
        cd ..

        # Install plugins.
        mkdir -p $dropinDir/plugins

        # A bundle should be unpacked if the manifest matches this
        # pattern.
        unpackPat="Eclipse-BundleShape:\\s*dir"

        cd plugins
        for plugin in *.jar ; do
          pluginName=''${plugin%.jar}
          manifest=$(unzip -p $plugin META-INF/MANIFEST.MF)

          if [[ $manifest =~ $unpackPat ]] ; then
            mkdir $dropinDir/plugins/$pluginName
            unzip $plugin -d $dropinDir/plugins/$pluginName
          else
            cp -v $plugin $dropinDir/plugins/
          fi
        done
        cd ..
      '';
    });

  acejump = buildEclipsePlugin rec {
    name = "acejump-${version}";
    version = "1.0.0.201501181511";

    srcFeature = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/features/acejump.feature_${version}.jar";
      sha256 = "127xqrnns4h96g21c9zg0iblxprx3fg6fg0w5f413rf84415z884";
    };

    srcPlugin = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/plugins/acejump_${version}.jar";
      sha256 = "0mz79ca32yryidd1wijirvnmfg4j5q4g84vdspdi56z0r4xrja13";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/tobiasmelcher/EclipseAceJump;
      description = "Provides fast jumps to text based on initial letter";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  anyedittools = buildEclipsePlugin rec {
    name = "anyedit-${version}";
    version = "2.4.15.201504172030";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/AnyEditTools_${version}.jar";
      sha256 = "19hbwgqn02ghflbcp5cw3qy203mym5kwgzq4xrn0xcl8ckl5s2pp";
    };

    srcPlugin = fetchurl {
      url = "http://dl.bintray.com/iloveeclipse/plugins/de.loskutov.anyedit.AnyEditTools_${version}.jar";
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

  cdt = buildEclipseUpdateSite rec {
    name = "cdt-${version}";
    version = "8.7.0";

    src = fetchzip {
      stripRoot = false;
      url = "http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/tools/cdt/releases/8.7/${name}.zip";
      sha256 = "0qpcjcl6n98x7ys4qz8p1x5hhk2ydrgh8w3r1kqk0zc7liqrx7vg";
    };

    meta = with stdenv.lib; {
      homepage = https://eclipse.org/cdt/;
      description = "C/C++ development tooling";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.bjornfor ];
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

    srcFeature = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/features/com.github.eclipsecolortheme.feature_${version}.jar";
      sha256 = "128b9b1cib5ff0w1114ns5mrbrhj2kcm358l4dpnma1s8gklm8g2";
    };

    srcPlugin = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/plugins/com.github.eclipsecolortheme_${version}.jar";
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

    srcFeature = fetchurl {
      url = "http://www.mulgasoft.com/emacsplus/e4/update-site/features/com.mulgasoft.emacsplus.feature_${version}.jar";
      sha256 = "0wja3cd7gq8w25797fxnafvcncjnmlv8qkl5iwqj7zja2f45vka8";
    };

    srcPlugin = fetchurl {
      url = "http://www.mulgasoft.com/emacsplus/e4/update-site/plugins/com.mulgasoft.emacsplus_${version}.jar";
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

    srcFeature = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/features/edu.umd.cs.findbugs.plugin.eclipse_${version}.jar";
      sha256 = "1m9fav2xlb9wrx2d00lpnh2sy0w5yzawynxm6xhhbfdzd0vpfr9v";
    };

    srcPlugin = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/plugins/edu.umd.cs.findbugs.plugin.eclipse_${version}.jar";
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

  gnuarmeclipse = buildEclipseUpdateSite rec {
    name = "gnuarmeclipse-${version}";
    version = "2.8.1-201504061754";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/gnuarmeclipse/Current%20Releases/2.x/ilg.gnuarmeclipse.repository-${version}.zip";
      sha256 = "08jsnyis1ry62cidr9sl11ylyxbkwh834nlhx6qp31gh1l439px9";
    };

    meta = with stdenv.lib; {
      homepage = http://gnuarmeclipse.livius.net/;
      description = "GNU ARM Eclipse Plug-ins";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  jdt = buildEclipseUpdateSite rec {
    name = "jdt-${version}";
    version = "4.5";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5-201506032000/org.eclipse.jdt-4.5.zip";
      sha256 = "0zrdn26f7qsms2xfiyc049bhhh0czsbf989pgyq736b8hfmmh9iy";
    };

    meta = with stdenv.lib; {
      homepage = https://www.eclipse.org/jdt/;
      description = "Eclipse Java development tools";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  scala = buildEclipseUpdateSite rec {
    name = "scala-${version}";
    version = "4.1.1";

    src = fetchzip {
      url = "http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/update-site.zip";
      sha256 = "0x5cdcm7p2ynz5ryw041gb150sripf9i4m1yrfqklnn581yqm6y8";
    };

    meta = with stdenv.lib; {
      homepage = "http://scala-ide.org/";
      description = "The Scala IDE for Eclipse";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  testng = buildEclipsePlugin rec {
    name = "testng-${version}";
    version = "6.9.5.201508210528";

    srcFeature = fetchurl {
      url = "http://beust.com/eclipse/features/org.testng.eclipse_${version}.jar";
      sha256 = "0xalm7pvj0vx61isgkjkgj073b4hlqlzx6xnkrnnnyi0r212a26j";
    };

    srcPlugin = fetchurl {
      url = "http://beust.com/eclipse/plugins/org.testng.eclipse_${version}.jar";
      sha256 = "07wmivfvfsq6cjw5zwciajdxkfa7drk108jsr44gf4i1bv9fj055";
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
