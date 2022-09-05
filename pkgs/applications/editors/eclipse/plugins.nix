{ lib, stdenv, fetchurl, fetchzip, unzip }:

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

    meta = with lib; {
      homepage = "https://github.com/tobiasmelcher/EclipseAceJump";
      description = "Provides fast jumps to text based on initial letter";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.mit;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://mihai-nita.net/java/#ePluginAEC";
      description = "Adds support for ANSI escape sequences in the Eclipse console";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };

  antlr-runtime_4_5 = buildEclipsePluginBase rec {
    name = "antlr-runtime-4.5.3";

    src = fetchurl {
      url = "https://www.antlr.org/download/${name}.jar";
      sha256 = "0lm78i2annlczlc2cg5xvby0g1dyl0sh1y5xc2pymjlmr67a1g4k";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${name}.jar
    '';

    meta = with lib; {
      description = "A powerful parser generator for processing structured text or binary files";
      homepage = "https://www.antlr.org/";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

  antlr-runtime_4_7 = buildEclipsePluginBase rec {
    name = "antlr-runtime-4.7.1";

    src = fetchurl {
      url = "https://www.antlr.org/download/${name}.jar";
      sha256 = "07f91mjclacrvkl8a307w2abq5wcqp0gcsnh0jg90ddfpqcnsla3";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${name}.jar
    '';

    meta = with lib; {
      description = "A powerful parser generator for processing structured text or binary files";
      homepage = "https://www.antlr.org/";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

  anyedittools = buildEclipsePlugin rec {
    name = "anyedit-${version}";
    version = "2.7.2.202006062100";

    srcFeature = fetchurl {
      url = "https://github.com/iloveeclipse/plugins/blob/latest/features/AnyEditTools_${version}.jar";
      sha256 = "0dwwwvz8by10f5gnws1ahmg02g6v4xbaqcwc0cydvv1h52cyb40g";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/iloveeclipse/plugins/blob/latest/plugins/de.loskutov.anyedit.AnyEditTools_${version}.jar";
      sha256 = "1ip8dk92ka7bczw1bkbs3zkclmwr28ds5q1wrzh525wb70x8v6fi";
    };

    meta = with lib; {
      homepage = "https://github.com/iloveeclipse/plugins";
      description = "Adds new tools to the context menu of text-based editors";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://github.com/cypher256/eclipse-encoding-plugin";
      description = "Show file encoding and line ending for the active editor in the eclipse status bar";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
    };
  };

  bytecode-outline = buildEclipsePlugin rec {
    name = "bytecode-outline-${version}";
    version = "1.0.1.202006062100";

    srcFeature = fetchurl {
      url = "https://github.com/iloveeclipse/plugins/blob/latest/features/org.eclipse.jdt.bcoview.feature_${version}.jar";
      sha256 = "0zbcph72lgv8cb5n4phcl3qsybc5q5yviwbv8yjv4v12m4l15wpk";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/iloveeclipse/plugins/blob/latest/plugins/org.eclipse.jdt.bcoview_${version}.jar";
      sha256 = "1bx860k4haqcnhy8825kn4df0pyzd680qbnvjmxfrlxrqhr66fbb";
    };

    meta = with lib; {
      homepage = "https://github.com/iloveeclipse/plugins";
      description = "Shows disassembled bytecode of current java editor or class file";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.bsd2;
      platforms = platforms.all;
    };
  };

  cdt = buildEclipseUpdateSite rec {
    name = "cdt-${version}";
    # find current version at https://www.eclipse.org/cdt/downloads.php
    version = "10.7.0";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/tools/cdt/releases/${lib.versions.majorMinor version}/${name}/${name}.zip";
      hash = "sha256-/lQ3TLFQ1IgwYM540gxAFiEGOfHQIQQMf/pqCZ29ztQ=";
    };

    meta = with lib; {
      homepage = "https://eclipse.org/cdt/";
      description = "C/C++ development tooling";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
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

    meta = with lib; {
      homepage = "https://eclipse-cs.sourceforge.net/";
      description = "Checkstyle integration into the Eclipse IDE";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.lgpl21;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "http://eclipsecolorthemes.org/";
      description = "Plugin to switch color themes conveniently and without side effects";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "http://www2.cs.tum.edu/projects/cup/eclipse.php";
      description = "IDE for developing CUP based parsers";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      platforms = platforms.all;
      maintainers = [ maintainers.romildo ];
    };
  };

  drools = buildEclipseUpdateSite rec {
    name = "drools-${version}";
    version = "7.17.0.Final";

    src = fetchzip {
      url = "https://download.jboss.org/drools/release/${version}/droolsjbpm-tools-distribution-${version}.zip";
      sha512 = "2qzc1iszqfrfnw8xip78n3kp6hlwrvrr708vlmdk7nv525xhs0ssjaxriqdhcr0s6jripmmazxivv3763rnk2bfkh31hmbnckpx4r3m";
      postFetch = ''
        # update site is a couple levels deep, alongside some other irrelevant stuff
        cd $out;
        find . -type f -not -path ./binaries/org.drools.updatesite/\* -exec rm {} \;
        rmdir sources;
        mv binaries/org.drools.updatesite/* .;
        rmdir binaries/org.drools.updatesite binaries;
      '';
    };

    meta = with lib; {
      homepage = "https://www.drools.org/";
      description = "Drools is a Business Rules Management System (BRMS) solution";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
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

    meta = with lib; {
      homepage = "https://www.eclemma.org/";
      description = "EclEmma is a free Java code coverage tool for Eclipse";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "http://findbugs.sourceforge.net/";
      description = "Plugin that uses static analysis to look for bugs in Java code";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
    };
  };

  freemarker = buildEclipseUpdateSite rec {
    name = "freemarker-${version}";
    version = "1.5.305";

    src = fetchzip {
      url = "https://github.com/ddekany/jbosstools-freemarker/releases/download/v${version}/freemarker.site-${version}.zip";
      sha256 = "1qrhi300vk07gi14r445wvy0bvghbjd6c4k7q09pqpaxv6raiczn";
      stripRoot = false;
    };

    meta = with lib; {
      homepage = "https://github.com/ddekany/jbosstools-freemarker";
      description = "Plugin that provides an editor for Apache FreeMarker files";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
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

    meta = with lib; {
      homepage = "http://gnuarmeclipse.livius.net/";
      description = "GNU ARM Eclipse Plug-ins";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
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

    meta = with lib; {
      description = "Adds support for JSON files to Eclipse";
      homepage = "https://github.com/boothen/Json-Eclipse-Plugin";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://github.com/angelozerr/jdt-codemining";
      description = "Provides JDT Java CodeMining";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
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
      postFetch =
        ''
          mv "$out/${repo}-${rev}/releases/local-repo/"* "$out/"
        '';
    };

    meta = with lib; {
      homepage = "https://github.com/RustDT";
      description = "Rust development tooling";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
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

    meta = with lib; {
      homepage = "http://scala-ide.org/";
      description = "The Scala IDE for Eclipse";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.bsd3;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://spotbugs.github.io/";
      description = "Plugin that uses static analysis to look for bugs in Java code";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.lgpl21;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://testng.org/doc/";
      description = "Eclipse plugin for the TestNG testing framework";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
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

    meta = with lib; {
      homepage = "https://github.com/vrapper/vrapper";
      description = "A wrapper to provide a Vim-like input scheme for moving around and editing text";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
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

    meta = with lib; {
      homepage = "https://github.com/oyse/yedit";
      description = "A YAML editor plugin for Eclipse";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.epl10;
      platforms = platforms.all;
    };
  };

  zest = buildEclipseUpdateSite rec {
    name = "zest-${version}";
    version = "3.9.101";

    src = fetchurl {
      url = "http://archive.eclipse.org/tools/gef/downloads/drops/${version}/R201408150207/GEF-${name}.zip";
      sha256 = "01scn7cmcrjcp387spjm8ifgwrwwi77ypildandbisfvhj3qqs7m";
    };

    meta = with lib; {
      homepage = "https://www.eclipse.org/gef/zest/";
      description = "The Eclipse Visualization Toolkit";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      platforms = platforms.all;
      maintainers = [ maintainers.romildo ];
    };
  };

  ivyde = buildEclipsePlugin rec {
    name = "ivyde-${version}";
    version = "2.2.0.final-201311091524-RELEASE";

    srcFeature = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivyde-${version}/features/org.apache.ivyde.feature_${version}.jar";
      sha1 = "c8fb6c4aab32db13db0bd81c1a148032667fff31";
    };

    srcPlugin = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivyde-${version}/plugins/org.apache.ivyde.eclipse_${version}.jar";
      sha1 = "0c80c2e228a07f18efab1c56ea026448eda70c06";
    };

    meta = with lib; {
      homepage = "https://ant.apache.org/ivy/ivyde/index.html";
      description = "A plugin which integrates Apache Ivy's dependency management";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.r3dl3g ];
    };
  };

  ivyderv = buildEclipsePlugin rec {
    name = "ivyderv-${version}";
    version = "2.2.0.final-201311091524-RELEASE";

    srcFeature = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivyde-${version}/features/org.apache.ivyde.eclipse.resolvevisualizer.feature_${version}.jar";
      sha1 = "fb1941eaa2c0de54259de01b0da6d5a6b4a2cab1";
    };

    srcPlugin = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivyde-${version}/plugins/org.apache.ivyde.eclipse.resolvevisualizer_${version}.jar";
      sha1 = "225e0c8ccb010d622c159560638578c2fc51a67e";
    };

    meta = with lib; {
      homepage = "https://ant.apache.org/ivy/ivyde/index.html";
      description = "A graph viewer of the resolved dependencies.";
      longDescription = ''
        Apache IvyDE Resolve Visualizer is an optional dependency of Apache IvyDE since
        it requires additional plugins to be installed (Zest).
      '';
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.r3dl3g ];
    };
  };

  ivy = buildEclipsePlugin rec {
    name = "ivy-${version}";
    version = "2.5.0.final_20191020104435";

    srcFeature = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivy-${version}/features/org.apache.ivy.eclipse.ant.feature_${version}.jar";
      sha256 = "de6134171a0edf569bb9b4c3a91639d469f196e86804d218adfdd60a5d7fa133";
    };

    srcPlugin = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivy-${version}/plugins/org.apache.ivy.eclipse.ant_${version}.jar";
      sha256 = "9e8ea20480cf73d0f0f3fb032d263c7536b24fd2eef71beb7d62af4e065f9ab5";
    };

    meta = with lib; {
      homepage = "https://ant.apache.org/ivy/index.html";
      description = "A popular dependency manager focusing on flexibility and simplicity";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.r3dl3g ];
    };
  };

  ivyant = buildEclipsePlugin rec {
    name = "ivyant-${version}";
    version = "2.5.0.final_20191020104435";

    srcFeature = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivy-${version}/features/org.apache.ivy.eclipse.ant.feature_${version}.jar";
      sha256 = "de6134171a0edf569bb9b4c3a91639d469f196e86804d218adfdd60a5d7fa133";
    };

    srcPlugin = fetchurl {
      url = "https://downloads.apache.org/ant/ivyde/updatesite/ivy-${version}/plugins/org.apache.ivy.eclipse.ant_${version}.jar";
      sha256 = "9e8ea20480cf73d0f0f3fb032d263c7536b24fd2eef71beb7d62af4e065f9ab5";
    };

    meta = with lib; {
      homepage = "https://ant.apache.org/ivy/ivyde/index.html";
      description = "Ant Tasks integrated into Eclipse's Ant runtime";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ maintainers.r3dl3g ];
    };
  };
}
