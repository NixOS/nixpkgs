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
    version = "2.6.0.201511291145";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/AnyEditTools_${version}.jar";
      sha256 = "1vllci75qcd28b6hn2jz29l6cabxx9ql5i6l9cwq9rxp49dhc96b";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/iloveeclipse/anyedittools/releases/download/2.6.0/de.loskutov.anyedit.AnyEditTools_${version}.jar";
      sha256 = "0mgq0ylfa7srjf7azyx0kbahlsjf0sdpazqphzx4f0bfn1l328s4";
    };

    meta = with stdenv.lib; {
      homepage = http://andrei.gmxhome.de/anyedit/;
      description = "Adds new tools to the context menu of text-based editors";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  bytecode-outline = buildEclipsePlugin rec {
    name = "bytecode-outline-${version}";
    version = "2.4.3";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/de.loskutov.BytecodeOutline.feature_${version}.jar";
      sha256 = "0imhwp73gxy1y5d5gpjgd05ywn0xg3vqc5980wcx3fd51g4ifc67";
    };

    srcPlugin = fetchurl {
      url = "http://dl.bintray.com/iloveeclipse/plugins/de.loskutov.BytecodeOutline_${version}.jar";
      sha256 = "0230i88mvvxhn11m9c5mv3494zhh1xkxyfyva9qahck0wbqwpzkw";
    };

    meta = with stdenv.lib; {
      homepage = http://andrei.gmxhome.de/bytecode/;
      description = "Shows disassembled bytecode of current java editor or class file";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  cdt = buildEclipseUpdateSite rec {
    name = "cdt-${version}";
    version = "8.8.0";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/tools/cdt/releases/8.8/${name}.zip";
      sha256 = "1i1m7g5128q21njgrkiw71y4vi4aqzz8xdd4iv80j3nsvhbv6cnm";
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
    version = "6.16.0.201603042325";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclipse-cs/Eclipse%20Checkstyle%20Plug-in/6.16.0/net.sf.eclipsecs-updatesite_${version}.zip";
      sha256 = "0bm1linyw82bryblyabcx89zqw1ingh8mx62bwp3qj05yc9ksnly";
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

  cup = buildEclipsePluginBase rec {
    name = "cup-${version}";
    version = "1.0.0.201412081321";

    srcFeature = fetchurl {
      url = "http://www2.in.tum.de/projects/cup/eclipse/features/CupEclipsePluginFeature_${version}.jar";
      sha256 = "353513445f77ed144687bafc20ab85dc31f2f95ffdc47f102ab773ab0b7afb8b";
    };

    srcPlugin1 = fetchurl {
      url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/CupReferencedLibraries_${version}.jar";
      sha256 = "082b5ed8730ad065efaac6ea2812dae15669ae74a49778911125b171bea41187";
    };

    srcPlugin2 = fetchurl {
      url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/de.tum.in.www2.CupPlugin_${version}.jar";
      sha256 = "6b67937fa11944b0330173a9d8564a19eccd705e76b96291d80077a1d7344939";
    };

    srcs = [ srcFeature srcPlugin1 srcPlugin2 ];

    propagatedBuildInputs = [ zest ];

    phases = [ "installPhase" ];

    installPhase = ''
      dropinDir="$out/eclipse/dropins/${name}"
      mkdir -p $dropinDir/features
      unzip ${srcFeature} -d $dropinDir/features/
      mkdir -p $dropinDir/plugins
      cp -v ${srcPlugin1} $dropinDir/plugins/''${srcPlugin1#*-}
      cp -v ${srcPlugin2} $dropinDir/plugins/''${srcPlugin2#*-}
    '';

    meta = with stdenv.lib; {
      homepage = http://www2.cs.tum.edu/projects/cup/eclipse.php;
      description = "IDE for developing CUP based parsers";
      platforms = platforms.all;
      maintainers = [ maintainers.romildo ];
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
    version = "2.11.1-201512141335";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/gnuarmeclipse/plug-ins/releases/download/v${version}/ilg.gnuarmeclipse.repository-${version}.zip";
      sha256 = "1ijvnahfw2wc860la7kj8b52z2sfm8k1yk62bl0d4lq60y3aycg9";
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
    version = "4.5.1";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.1-201509040015/org.eclipse.jdt-4.5.1.zip";
      sha256 = "0nxi552vvpjalnsqhc0zi6fgaj9p22amxsiczpv7za4kr7m47x73";
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
    version = "4.4.0.201604010956";

    src = fetchzip {
      url = "http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/update-site.zip";
      sha256 = "1yypzcf2iwlcj43vd6h9n4y2ka1gxjf5vm3yx87bgfbzbchzckz7";
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
    version = "6.9.11.201603260617";

    srcFeature = fetchurl {
      url = "http://beust.com/eclipse-old/eclipse_${version}/features/org.testng.eclipse_${version}.jar";
      sha256 = "0cd7d3bdp6f081vrampsv53z55g1mjn04w9ngz3h8dr0h6jnxz3y";
    };

    srcPlugin = fetchurl {
      url = "http://beust.com/eclipse-old/eclipse_${version}/plugins/org.testng.eclipse_${version}.jar";
      sha256 = "10kdwnydmsvngn8ahijxrv50aps6wa4ckbf7p24mxbwlnmpqfj03";
    };

    meta = with stdenv.lib; {
      homepage = http://testng.org/;
      description = "Eclipse plugin for the TestNG testing framework";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  zest = buildEclipseUpdateSite rec {
    name = "zest-${version}";
    version = "3.9.101";

    src = fetchurl {
      url = "http://archive.eclipse.org/tools/gef/downloads/drops/${version}/R201408150207/GEF-${name}.zip";
      sha256 = "01scn7cmcrjcp387spjm8ifgwrwwi77ypildandbisfvhj3qqs7m";
    };

    meta = with stdenv.lib; {
      homepage = https://www.eclipse.org/gef/zest/;
      description = "The Eclipse Visualization Toolkit";
      platforms = platforms.all;
      maintainers = [ maintainers.romildo ];
    };
  };

}
