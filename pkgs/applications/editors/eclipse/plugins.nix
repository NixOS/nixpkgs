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
  buildEclipsePlugin =
    { name, srcFeature, srcPlugin ? null, srcPlugins ? [], ... } @ attrs:
      assert srcPlugin == null -> srcPlugins != [];
      assert srcPlugin != null -> srcPlugins == [];

      let

        pSrcs = if (srcPlugin != null) then [ srcPlugin ] else srcPlugins;

      in

        buildEclipsePluginBase (attrs // {
          srcs = [ srcFeature ] ++ pSrcs;

          buildCommand = ''
            dropinDir="$out/eclipse/dropins/${name}"

            mkdir -p $dropinDir/features
            unzip ${srcFeature} -d $dropinDir/features/

            mkdir -p $dropinDir/plugins
            for plugin in ${toString pSrcs}; do
              cp -v $plugin $dropinDir/plugins/$(stripHash $plugin)
            done
          '';
        });

  # Helper for the case where the build directory has the layout of an
  # Eclipse update site, that is, it contains the directories
  # `features` and `plugins`. All features and plugins inside these
  # directories will be installed.
  buildEclipseUpdateSite = { name, ... } @ attrs:
    buildEclipsePluginBase (attrs // {
      dontBuild = true;
      doCheck = false;

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
    version = "1.0.0.201610261941";

    srcFeature = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/features/acejump.feature_${version}.jar";
      sha256 = "1szswjxp9g70ibfbv3p8dlq1bngq7nc22kp657z9i9kp8309md2d";
    };

    srcPlugin = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/plugins/acejump_${version}.jar";
      sha256 = "1cn64xj2bm69vnn9db2xxh6kq148v83w5nx3183mrqb59ym3v9kf";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/tobiasmelcher/EclipseAceJump;
      description = "Provides fast jumps to text based on initial letter";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  ansi-econsole = buildEclipsePlugin rec {
    name = "ansi-econsole-${version}";
    version = "1.3.5.201612301822";

    srcFeature = fetchurl {
      url = "https://mihnita.github.io/ansi-econsole/install/features/net.mihai-nita.ansicon_${version}.jar";
      sha256 = "086ylxpsrlpbvwv5mw7v6b44j63cwzgi8apg2mq058ydr5ak6hxs";
    };

    srcPlugin = fetchurl {
      url = "https://mihnita.github.io/ansi-econsole/install/plugins/net.mihai-nita.ansicon.plugin_${version}.jar";
      sha256 = "1j42l0xxzs89shqkyn91lb0gia10mifzy0i73c3n7gj7sv2ddbjq";
    };

    meta = with stdenv.lib; {
      homepage = "https://mihai-nita.net/java/#ePluginAEC";
      description = "Adds support for ANSI escape sequences in the Eclipse console";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  antlr-runtime_4_5 = buildEclipsePluginBase rec {
    name = "antlr-runtime-4.5.3";

    src = fetchurl {
      url = "http://www.antlr.org/download/${name}.jar";
      sha256 = "0lm78i2annlczlc2cg5xvby0g1dyl0sh1y5xc2pymjlmr67a1g4k";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${name}.jar
    '';

    meta = with stdenv.lib; {
      description = "A powerful parser generator for processing structured text or binary files";
      homepage = http://www.antlr.org/;
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  antlr-runtime_4_7 = buildEclipsePluginBase rec {
    name = "antlr-runtime-4.7.1";

    src = fetchurl {
      url = "http://www.antlr.org/download/${name}.jar";
      sha256 = "07f91mjclacrvkl8a307w2abq5wcqp0gcsnh0jg90ddfpqcnsla3";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${name}.jar
    '';

    meta = with stdenv.lib; {
      description = "A powerful parser generator for processing structured text or binary files";
      homepage = http://www.antlr.org/;
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  anyedittools = buildEclipsePlugin rec {
    name = "anyedit-${version}";
    version = "2.7.1.201709201439";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/AnyEditTools_${version}.jar";
      sha256 = "1wqzl7wq85m9gil8rnvly45ps0a2m0svw613pg6djs5i7amhnayh";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/iloveeclipse/anyedittools/releases/download/2.7.1/de.loskutov.anyedit.AnyEditTools_${version}.jar";
      sha256 = "03iyb6j2srq74iigmg7dk098c2svyv0ygdfql5jqr44a32n07k8q";
    };

    meta = with stdenv.lib; {
      homepage = http://andrei.gmxhome.de/anyedit/;
      description = "Adds new tools to the context menu of text-based editors";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  autodetect-encoding = buildEclipsePlugin rec {
    name = "autodetect-encoding-${version}";
    version = "1.8.5.201801191359";

    srcFeature = fetchurl {
      url = "https://github.com/cypher256/eclipse-encoding-plugin/raw/master/eclipse.encoding.updatesite.snapshot/features/eclipse.encoding.plugin.feature_${version}.jar";
      sha256 = "1m8ypsc1dwz0y6yhjgxsdi9813d38jllv7javgwvcd30g042a3kx";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/cypher256/eclipse-encoding-plugin/raw/master/eclipse.encoding.updatesite.snapshot/plugins/mergedoc.encoding_${version}.jar";
      sha256 = "1n2rzybfcwp3ss2qi0fhd8vm38vdwav8j837lqiqlfcnvzwsk86m";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/cypher256/eclipse-encoding-plugin;
      description = "Show file encoding and line ending for the active editor in the eclipse status bar";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  bytecode-outline = buildEclipsePlugin rec {
    name = "bytecode-outline-${version}";
    version = "2.5.0.201711011753-5a57fdf";

    srcFeature = fetchurl {
      url = "http://andrei.gmxhome.de/eclipse/features/de.loskutov.BytecodeOutline.feature_${version}.jar";
      sha256 = "0yciqhcq0n5i326mwy57r4ywmkz2c2jky7r4pcmznmhvks3z65ps";
    };

    srcPlugin = fetchurl {
      url = "http://dl.bintray.com/iloveeclipse/plugins/de.loskutov.BytecodeOutline_${version}.jar";
      sha256 = "1vmsqv32jfl7anvdkw0vir342miv5sr9df7vd1w44lf1yf97vxlw";
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
    version = "9.0.1";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/tools/cdt/releases/9.0/${name}.zip";
      sha256 = "0vdx0j9ci533wnk7y17qjvjyqx38hlrdw67z6pi05vfv3r6ys39x";
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
    version = "8.7.0.201801131309";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclipse-cs/Eclipse%20Checkstyle%20Plug-in/8.7.0/net.sf.eclipsecs-updatesite_${version}.zip";
      sha256 = "07fymk705x4mwq7vh2i6frsf67jql4bzrkdzhb4n74zb0g1dib60";
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

  cup = buildEclipsePlugin rec {
    name = "cup-${version}";
    version = "1.1.0.201604221613";
    version_ = "1.0.0.201604221613";

    srcFeature = fetchurl {
      url = "http://www2.in.tum.de/projects/cup/eclipse/features/CupEclipsePluginFeature_${version}.jar";
      sha256 = "13nnsf0cqg02z3af6xg45rhcgiffsibxbx6h1zahjv7igvqgkyna";
    };

    srcPlugins = [
      (fetchurl {
        url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/CupReferencedLibraries_${version_}.jar";
        sha256 = "0kif8kivrysprva1pxzajm88gi967qf7idhb6ga2xpvsdcris91j";
      })

      (fetchurl {
        url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/de.tum.in.www2.CupPlugin_${version}.jar";
        sha256 = "022phbrsny3gb8npb6sxyqqxacx138q5bd7dq3gqxh3kprx5chbl";
      })
    ];

    propagatedBuildInputs = [ zest ];

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
    version = "3.1.1-201606210758";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/gnuarmeclipse/plug-ins/releases/download/v${version}/ilg.gnuarmeclipse.repository-${version}.zip";
      sha256 = "1g77jlhfa3csaxxps1z5lasrd9l2p5ajnddnq9ra5syw8ggkdc2h";
    };

    meta = with stdenv.lib; {
      homepage = http://gnuarmeclipse.livius.net/;
      description = "GNU ARM Eclipse Plug-ins";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  jsonedit = buildEclipsePlugin rec {
    name = "jsonedit-${version}";
    version = "1.1.1";

    srcFeature = fetchurl {
      url = "https://boothen.github.io/Json-Eclipse-Plugin/features/jsonedit-feature_${version}.jar";
      sha256 = "0zkg8d8x3l5jpfxi0mz9dn62wmy4fjgpwdikj280fvsklmcw5b86";
    };

    srcPlugins =
      let
        fetch = { n, h }:
          fetchurl {
            url = "https://boothen.github.io/Json-Eclipse-Plugin/plugins/jsonedit-${n}_${version}.jar";
            sha256 = h;
          };
      in
        map fetch [
          { n = "core"; h = "0svs0aswnhl26cqw6bmw30cisx4cr50kc5njg272sy5c1dqjm1zq"; }
          { n = "editor"; h = "1q62dinrbb18aywbvii4mlr7rxa20rdsxxd6grix9y8h9776q4l5"; }
          { n = "folding"; h = "1qh4ijfb1gl9xza5ydi87v1kyima3a9sh7lncwdy1way3pdhln1y"; }
          { n = "model"; h = "1pr6k2pdfdwx8jqs7gx7wzn3gxsql3sk6lnjha8m15lv4al6d4kj"; }
          { n = "outline"; h = "1jgr2g16j3id8v367jbgd6kx6g2w636fbzmd8jvkvkh7y1jgjqxm"; }
          { n = "preferences"; h = "027fhaqa5xbil6dmhvkbpha3pgw6dpmc2im3nlliyds57mdmdb1h"; }
          { n = "text"; h = "0clywylyidrxlqs0n816nhgjmk1c3xl7sn904ki4q050amfy0wb2"; }
        ];

    propagatedBuildInputs = [ antlr-runtime_4_7 ];

    meta = with stdenv.lib; {
      description = "Adds support for JSON files to Eclipse";
      homepage = https://github.com/boothen/Json-Eclipse-Plugin;
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  jdt = buildEclipseUpdateSite rec {
    name = "jdt-${version}";
    version = "4.9";

    src = fetchzip {
      stripRoot = false;
      url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.9-201809060745/org.eclipse.jdt-4.9.zip;
      sha256 = "144rqrw0crxd2v862dqxm2p5y60n4pbzdryv709xnhcw54rycm7n";
    };

    meta = with stdenv.lib; {
      homepage = https://www.eclipse.org/jdt/;
      description = "Eclipse Java development tools";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  jdt-codemining = buildEclipsePlugin rec {
    name = "jdt-codemining-${version}";
    version = "1.0.0.201806221018";

    srcFeature = fetchurl {
      url = "http://oss.opensagres.fr/jdt-codemining/snapshot/features/jdt-codemining-feature_${version}.jar";
      sha256 = "1vy30rsb9xifn4r1r2n84d48g6riadzli1xvhfs1mf5pkm5ljwl6";
    };

    srcPlugin = fetchurl {
      url = "http://oss.opensagres.fr/jdt-codemining/snapshot/plugins/org.eclipse.jdt.codemining_${version}.jar";
      sha256 = "0qdzlqcjcm2i4mwhmcdml0am83z1dayrcmf37ji7vmw6iwdk1xmp";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/angelozerr/jdt-codemining;
      description = "Provides JDT Java CodeMining";
      license = licenses.epl10;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  rustdt = buildEclipseUpdateSite rec {
    name = "rustdt-${version}";
    version = "0.6.2";
    owner = "RustDT";
    repo = "rustdt.github.io";
    rev = "5cbe753008c40555c493092a6f4ae1ffbff0b3ce";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/${owner}/${repo}/archive/${rev}.zip";
      sha256 = "1xfj4j27d1h4bdf2v7f78zi8lz4zkkj7s9kskmsqx5jcs2d459yp";
      extraPostFetch =
        ''
          mv "$out/${repo}-${rev}/releases/local-repo/"* "$out/"
        '';
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/RustDT;
      description = "Rust development tooling";
      license = licenses.epl10;
      platforms = platforms.all;
    };
  };

  scala = buildEclipseUpdateSite rec {
    name = "scala-${version}";
    version = "4.4.1.201605041056";

    src = fetchzip {
      url = "http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/base-20160504-1321.zip";
      sha256 = "13xgx2rwlll0l4bs0g6gyvrx5gcc0125vzn501fdj0wv2fqxn5lw";
    };

    meta = with stdenv.lib; {
      homepage = http://scala-ide.org/;
      description = "The Scala IDE for Eclipse";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  spotbugs = buildEclipseUpdateSite rec {
    name = "spotbugs-${version}";
    version = "3.1.11";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/spotbugs/spotbugs/releases/download/${version}/eclipsePlugin.zip";
      sha256 = "0aanqwx3gy1arpbkqd846381hiy6272lzwhfjl94x8jhfykpqqbj";
    };

    meta = with stdenv.lib; {
      homepage = https://spotbugs.github.io/;
      description = "Plugin that uses static analysis to look for bugs in Java code";
      license = licenses.lgpl21;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  testng = buildEclipsePlugin rec {
    name = "testng-${version}";
    version = "6.9.13.201609291640";

    srcFeature = fetchurl {
      url = "http://beust.com/eclipse-old/eclipse_${version}/features/org.testng.eclipse_${version}.jar";
      sha256 = "02wzcysl7ga3wnvnwp6asl8d77wgc547c5qqawixw94lw6fn1a15";
    };

    srcPlugin = fetchurl {
      url = "http://beust.com/eclipse-old/eclipse_${version}/plugins/org.testng.eclipse_${version}.jar";
      sha256 = "1j4zw6392q3q6z3pcy803k3g0p220gk1x19fs99p0rmmdz83lc8d";
    };

    meta = with stdenv.lib; {
      homepage = http://testng.org/;
      description = "Eclipse plugin for the TestNG testing framework";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  vrapper = buildEclipseUpdateSite rec {
    name = "vrapper-${version}";
    version = "0.72.0";
    owner = "vrapper";
    repo = "vrapper";
    date = "20170311";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/${owner}/${repo}/releases/download/${version}/vrapper_${version}_${date}.zip";
      sha256 = "0nyirf6km97q211cxfy01kidxac20m8ba3kk9xj73ykrhsk3cxjp";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/vrapper/vrapper";
      description = "A wrapper to provide a Vim-like input scheme for moving around and editing text";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = [ maintainers.stumoss ];
    };
  };

  yedit = buildEclipsePlugin rec {
    name = "yedit-${version}";
    version = "1.0.20.201509041456";

    srcFeature = fetchurl {
      url = "http://dadacoalition.org/yedit/features/org.dadacoalition.yedit.feature_${version}-RELEASE.jar";
      sha256 = "0rps73y19gwlrdr8jjrg3rhcaaagghnmri8297inxc5q2dvg0mlk";
    };

    srcPlugin = fetchurl {
      url = "http://dadacoalition.org/yedit/plugins/org.dadacoalition.yedit_${version}-RELEASE.jar";
      sha256 = "1wpyw4z28ka60z36f8m71kz1giajcm26wb9bpv18sjiqwdgx9v0z";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/oyse/yedit;
      description = "A YAML editor plugin for Eclipse";
      license = licenses.epl10;
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
