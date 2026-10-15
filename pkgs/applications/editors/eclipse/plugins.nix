{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  unzip,
  config,
}:

rec {

  # A primitive builder of Eclipse plugins. This function is intended
  # to be used when building more advanced builders.
  buildEclipsePluginBase =
    {
      name ? "eclipse-plugin-${attrs.pname}-${attrs.version}",
      buildInputs ? [ ],
      passthru ? { },
      ...
    }@attrs:
    stdenv.mkDerivation (
      attrs
      // {
        inherit name;

        buildInputs = buildInputs ++ [ unzip ];

        passthru = {
          isEclipsePlugin = true;
        }
        // passthru;
      }
    );

  # Helper for the common case where we have separate feature and
  # plugin JARs.
  buildEclipsePlugin =
    {
      name ? "eclipse-plugin-${attrs.pname}-${attrs.version}",
      srcFeature,
      srcPlugin ? null,
      srcPlugins ? [ ],
      ...
    }@attrs:
    assert srcPlugin == null -> srcPlugins != [ ];
    assert srcPlugin != null -> srcPlugins == [ ];

    let

      pSrcs = if (srcPlugin != null) then [ srcPlugin ] else srcPlugins;

    in

    buildEclipsePluginBase (
      attrs
      // {
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
      }
    );

  # Helper for the case where the build directory has the layout of an
  # Eclipse update site, that is, it contains the directories
  # `features` and `plugins`. All features and plugins inside these
  # directories will be installed.
  buildEclipseUpdateSite =
    {
      name ? "eclipse-plugin-${attrs.pname}-${attrs.version}",
      ...
    }@attrs:
    buildEclipsePluginBase (
      attrs
      // {
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
      }
    );

  acejump = buildEclipsePlugin rec {
    pname = "acejump";
    version = "1.0.0.201610261941";

    srcFeature = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/features/acejump.feature_${version}.jar";
      hash = "sha256-TbSawEB3ppj+KeZOIZg9+NkVMG3ojr3ciuC8dLvk+us=";
    };

    srcPlugin = fetchurl {
      url = "https://tobiasmelcher.github.io/acejumpeclipse/plugins/acejump_${version}.jar";
      hash = "sha256-bqY9qk9l4VwHCqPbwgfaiAQ8DexdrJas3cnUJWQnxrI=";
    };

    meta = {
      homepage = "https://github.com/tobiasmelcher/EclipseAceJump";
      description = "Provides fast jumps to text based on initial letter";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  };

  ansi-econsole = buildEclipsePlugin rec {
    pname = "ansi-econsole";
    version = "1.3.5.201612301822";

    srcFeature = fetchurl {
      url = "https://raw.githubusercontent.com/mihnita/ansi-econsole/8dcf0a2531cbf091310c0e01db1a1310557fc383/AnsiConSitePublished/features/net.mihai-nita.ansicon_${version}.jar";
      hash = "sha256-o9hnMuZeohU+AKS+ueU8dWS9HomrnqaKpWYMG5vMeJs=";
    };

    srcPlugin = fetchurl {
      url = "https://raw.githubusercontent.com/mihnita/ansi-econsole/8dcf0a2531cbf091310c0e01db1a1310557fc383/AnsiConSitePublished/plugins/net.mihai-nita.ansicon.plugin_${version}.jar";
      hash = "sha256-WK7WxNZHvmMHGycC/12sIKj4wKIhWT8x1Anp3zuggsg=";
    };

    meta = {
      homepage = "https://mihai-nita.net/java/#ePluginAEC";
      description = "Adds support for ANSI escape sequences in the Eclipse console";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  };

  antlr-runtime_4_5 = buildEclipsePluginBase rec {
    pname = "antlr-runtime";
    version = "4.5.3";

    src = fetchurl {
      url = "https://www.antlr.org/download/${pname}-${version}.jar";
      hash = "sha256-k7ygjsmVyuqvYL34ADWgvoUH/Nq9PCYY/Yxaq0REp1I=";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${pname}-${version}.jar
    '';

    meta = {
      description = "Powerful parser generator for processing structured text or binary files";
      homepage = "https://www.antlr.org/";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  };

  antlr-runtime_4_7 = buildEclipsePluginBase rec {
    pname = "antlr-runtime";
    version = "4.7.1";

    src = fetchurl {
      url = "https://www.antlr.org/download/${pname}-${version}.jar";
      hash = "sha256-Q1FtGb6uNZCeBNBq9sDFjBe8lOAHDIXo3JkpymQNyR0=";
    };

    buildCommand = ''
      dropinDir="$out/eclipse/dropins/"
      mkdir -p $dropinDir
      cp -v $src $dropinDir/${pname}-${version}.jar
    '';

    meta = {
      description = "Powerful parser generator for processing structured text or binary files";
      homepage = "https://www.antlr.org/";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  };

  anyedittools = buildEclipsePlugin rec {
    pname = "anyedit";
    version = "2.7.3.202502241151";

    srcFeature = fetchurl {
      url = "https://raw.githubusercontent.com/iloveeclipse/plugins/f0560d1c628e0dba776831b1dea98d929515ebe5/features/AnyEditTools_${version}.jar";
      hash = "sha256-liEw+H8yTCrYQMe3gVQhJuxPXlSpEs4QwB2yv8n/CiE=";
    };

    srcPlugin = fetchurl {
      url = "https://raw.githubusercontent.com/iloveeclipse/plugins/f0560d1c628e0dba776831b1dea98d929515ebe5/plugins/de.loskutov.anyedit.AnyEditTools_${version}.jar";
      hash = "sha256-LrWCWJWZxsnMiBnTwXdWaXUoyXMYpLqXMUkHEOna2kk=";
    };

    meta = {
      homepage = "https://github.com/iloveeclipse/plugins";
      description = "Adds new tools to the context menu of text-based editors";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  autodetect-encoding = buildEclipsePlugin rec {
    pname = "autodetect-encoding";
    version = "1.8.5.201801191359";

    srcFeature = fetchurl {
      url = "https://github.com/cypher256/eclipse-encoding-plugin/raw/master/eclipse.encoding.updatesite.snapshot/features/eclipse.encoding.plugin.feature_${version}.jar";
      hash = "sha256-fQ4lCHhgNLb520qeTalEo42AUmy6Pwm98eDzFpi+HtU=";
    };

    srcPlugin = fetchurl {
      url = "https://github.com/cypher256/eclipse-encoding-plugin/raw/master/eclipse.encoding.updatesite.snapshot/plugins/mergedoc.encoding_${version}.jar";
      hash = "sha256-1aCp+d+WOYojpmcgibbibaNRN2rQgYiF1uNy5pb/Wdg=";
    };

    meta = {
      homepage = "https://github.com/cypher256/eclipse-encoding-plugin";
      description = "Show file encoding and line ending for the active editor in the eclipse status bar";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  cdt = buildEclipseUpdateSite rec {
    pname = "cdt";
    # find current version at https://github.com/eclipse-cdt/cdt/releases
    version = "11.4.0";

    src = fetchzip {
      stripRoot = false;
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/tools/cdt/releases/${lib.versions.majorMinor version}/${pname}-${version}/${pname}-${version}.zip";
      hash = "sha256-39AoB5cKRQMFpRaOlrTEsyEKZYVqdTp1tMtlaDjjZ84=";
    };

    meta = {
      homepage = "https://eclipse.org/cdt/";
      description = "C/C++ development tooling";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.bjornfor ];
    };
  };

  checkstyle = buildEclipseUpdateSite rec {
    pname = "checkstyle";
    version = "8.7.0.201801131309";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclipse-cs/Eclipse%20Checkstyle%20Plug-in/8.7.0/net.sf.eclipsecs-updatesite_${version}.zip";
      hash = "sha256-wKzYwgPrk2PJgr/N/BehWB7jdHYmCrgP5pX0As6s3h0=";
    };

    meta = {
      homepage = "https://eclipse-cs.sourceforge.net/";
      description = "Checkstyle integration into the Eclipse IDE";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.all;
    };

  };

  color-theme = buildEclipsePlugin rec {
    pname = "color-theme";
    version = "1.0.0.201410260308";

    srcFeature = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/features/com.github.eclipsecolortheme.feature_${version}.jar";
      hash = "sha256-4qFK50M6qGpvIxSVUdkUEuaVa9GWhBA4cK6syMJKC4k=";
    };

    srcPlugin = fetchurl {
      url = "https://eclipse-color-theme.github.io/update/plugins/com.github.eclipsecolortheme_${version}.jar";
      hash = "sha256-HkBB6GKC4BhkHh0rGND1Vg3LgIpHUMrx/RzDlUAK5nM=";
    };

    meta = {
      homepage = "https://github.com/eclipse-color-theme/eclipse-color-theme";
      description = "Plugin to switch color themes conveniently and without side effects";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  cup = buildEclipsePlugin rec {
    pname = "cup";
    version = "1.1.0.201604221613";
    version_ = "1.0.0.201604221613";

    srcFeature = fetchurl {
      url = "http://www2.in.tum.de/projects/cup/eclipse/features/CupEclipsePluginFeature_${version}.jar";
      hash = "sha256-yvr58H7xbAnVD9D01VfUzsXHYC7kdePU+AI8zIDT1o4=";
    };

    srcPlugins = [
      (fetchurl {
        url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/CupReferencedLibraries_${version_}.jar";
        hash = "sha256-MiQdM2t63y7UMwu2eBw+JsWHUJXq9xvUzlf7vONELk4=";
      })

      (fetchurl {
        url = "http://www2.in.tum.de/projects/cup/eclipse/plugins/de.tum.in.www2.CupPlugin_${version}.jar";
        hash = "sha256-dEFWer5zwI7fwO20VTAaoTPVMfZdm3UtWm94q/OCVwg=";
      })
    ];

    propagatedBuildInputs = [ zest ];

    meta = {
      homepage = "http://www2.cs.tum.edu/projects/cup/eclipse.php";
      description = "IDE for developing CUP based parsers";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.romildo ];
    };
  };

  drools = buildEclipseUpdateSite rec {
    pname = "drools";
    version = "7.17.0.Final";

    src = fetchzip {
      url = "https://download.jboss.org/drools/release/${version}/droolsjbpm-tools-distribution-${version}.zip";
      hash = "sha512-dWTS72R2VRgGnG6JafMwZ+wd+1e13pil0SAz2HDMXUmtgYa9iLLtma3SjcDJeWdOoblzWHRu7Ihblx3+Ogb2sQ==";
      postFetch = ''
        # update site is a couple levels deep, alongside some other irrelevant stuff
        cd $out;
        find . -type f -not -path ./binaries/org.drools.updatesite/\* -exec rm {} \;
        rmdir sources;
        mv binaries/org.drools.updatesite/* .;
        rmdir binaries/org.drools.updatesite binaries;
      '';
    };

    meta = {
      homepage = "https://www.drools.org/";
      description = "Drools is a Business Rules Management System (BRMS) solution";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.asl20;
    };
  };

  eclemma = buildEclipseUpdateSite {
    pname = "eclemma";
    version = "2.3.2.201409141915";

    src = fetchzip {
      stripRoot = false;
      url = "mirror://sourceforge/project/eclemma/01_EclEmma_Releases/2.3.2/eclemma-2.3.2.zip";
      hash = "sha256-g7DRpClR0m7vVtuoqmR1NnOsm4mI3V22rucWAiXjM3A=";
    };

    meta = {
      homepage = "https://www.eclemma.org/";
      description = "EclEmma is a free Java code coverage tool for Eclipse";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  findbugs = buildEclipsePlugin rec {
    pname = "findbugs";
    version = "3.0.1.20150306-5afe4d1";

    srcFeature = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/features/edu.umd.cs.findbugs.plugin.eclipse_${version}.jar";
      hash = "sha256-O2V3N2i/uQVhN7Vbz9X3hQOvBbSXAtBEzzwt2sVWLtU=";
    };

    srcPlugin = fetchurl {
      url = "http://findbugs.cs.umd.edu/eclipse/plugins/edu.umd.cs.findbugs.plugin.eclipse_${version}.jar";
      hash = "sha256-GCleltMrmWISP0zjO4QqwMDszsZDsFoplCbydFeu44I=";
    };

    meta = {
      homepage = "http://findbugs.sourceforge.net/";
      description = "Plugin that uses static analysis to look for bugs in Java code";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  freemarker = buildEclipseUpdateSite rec {
    pname = "freemarker";
    version = "1.5.305";

    src = fetchzip {
      url = "https://github.com/ddekany/jbosstools-freemarker/releases/download/v${version}/freemarker.site-${version}.zip";
      hash = "sha256-9rOostldXXwTwGcSZppc8O0F/OaFkExCfAfMDcCIMOM=";
      stripRoot = false;
    };

    meta = {
      homepage = "https://github.com/ddekany/jbosstools-freemarker";
      description = "Plugin that provides an editor for Apache FreeMarker files";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    };
  };

  embed-cdt = buildEclipseUpdateSite rec {
    pname = "embed-cdt";
    version = "6.3.1";

    src = fetchzip {
      stripRoot = true;
      url = "https://github.com/eclipse-embed-cdt/eclipse-plugins/archive/v${version}.zip";
      hash = "sha256-0wHRIls48NGDQzD+wuX79Thgiax+VVYVPJw2Z6NEzsg=";
    };

    meta = {
      homepage = "https://github.com/eclipse-embed-cdt/eclipse-plugins";
      description = "Embedded C/C++ Development Tools (formerly GNU MCU/ARM Eclipse)";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl20;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.bjornfor ];
    };
  };
  gnuarmeclipse = embed-cdt; # backward compat alias, added 2022-11-04

  jsonedit = buildEclipsePlugin rec {
    pname = "jsonedit";
    version = "1.1.1";

    srcFeature = fetchurl {
      url = "https://boothen.github.io/Json-Eclipse-Plugin/features/jsonedit-feature_${version}.jar";
      hash = "sha256-Bq3CWaVTbweQkDM2fp90xFcujG3pVxC7u7LQ0VFDb34=";
    };

    srcPlugins =
      let
        fetch =
          { n, h }:
          fetchurl {
            url = "https://boothen.github.io/Json-Eclipse-Plugin/plugins/jsonedit-${n}_${version}.jar";
            sha256 = h;
          };
      in
      map fetch [
        {
          n = "core";
          h = "0svs0aswnhl26cqw6bmw30cisx4cr50kc5njg272sy5c1dqjm1zq";
        }
        {
          n = "editor";
          h = "1q62dinrbb18aywbvii4mlr7rxa20rdsxxd6grix9y8h9776q4l5";
        }
        {
          n = "folding";
          h = "1qh4ijfb1gl9xza5ydi87v1kyima3a9sh7lncwdy1way3pdhln1y";
        }
        {
          n = "model";
          h = "1pr6k2pdfdwx8jqs7gx7wzn3gxsql3sk6lnjha8m15lv4al6d4kj";
        }
        {
          n = "outline";
          h = "1jgr2g16j3id8v367jbgd6kx6g2w636fbzmd8jvkvkh7y1jgjqxm";
        }
        {
          n = "preferences";
          h = "027fhaqa5xbil6dmhvkbpha3pgw6dpmc2im3nlliyds57mdmdb1h";
        }
        {
          n = "text";
          h = "0clywylyidrxlqs0n816nhgjmk1c3xl7sn904ki4q050amfy0wb2";
        }
      ];

    propagatedBuildInputs = [ antlr-runtime_4_7 ];

    meta = {
      description = "Adds support for JSON files to Eclipse";
      homepage = "https://github.com/boothen/Json-Eclipse-Plugin";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  jdt-codemining = buildEclipsePlugin rec {
    pname = "jdt-codemining";
    version = "1.0.0.201806221018";

    srcFeature = fetchurl {
      url = "http://oss.opensagres.fr/jdt-codemining/snapshot/features/jdt-codemining-feature_${version}.jar";
      hash = "sha256-hnJJS523uBq0g7uHSH9TMZuHSCPIihwysS72tHQGw+8=";
    };

    srcPlugin = fetchurl {
      url = "http://oss.opensagres.fr/jdt-codemining/snapshot/plugins/org.eclipse.jdt.codemining_${version}.jar";
      hash = "sha256-t/YwG4+G132iPMNVlr1q4Q9UFaC1sQp5JVFUJhmmv2E=";
    };

    meta = {
      homepage = "https://github.com/angelozerr/jdt-codemining";
      description = "Provides JDT Java CodeMining";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  rustdt = buildEclipseUpdateSite rec {
    pname = "rustdt";
    version = "0.6.2";
    owner = "RustDT";
    repo = "rustdt.github.io";
    rev = "5cbe753008c40555c493092a6f4ae1ffbff0b3ce";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/${owner}/${repo}/archive/${rev}.zip";
      hash = "sha256-16dCmtBMlo51nXomfeScn3yK4kfHnS1cWwSGdoQk0vU=";
      postFetch = ''
        mv "$out/${repo}-${rev}/releases/local-repo/"* "$out/"
      '';
    };

    meta = {
      homepage = "https://github.com/RustDT";
      description = "Rust development tooling";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  spotbugs = buildEclipseUpdateSite rec {
    pname = "spotbugs";
    version = "3.1.11";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/spotbugs/spotbugs/releases/download/${version}/eclipsePlugin.zip";
      hash = "sha256-cmF8p3dQok4SlQ7yT8URxkcY0DAENTzXzSr4NzrHVik=";
    };

    meta = {
      homepage = "https://spotbugs.github.io/";
      description = "Plugin that uses static analysis to look for bugs in Java code";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.all;
    };
  };

  testng = buildEclipsePlugin rec {
    pname = "testng";
    version = "6.9.13.201609291640";

    srcFeature = fetchurl {
      url = "https://raw.githubusercontent.com/testng-team/testng-eclipse-update-site/0eb404d0c65dc0ef25b19145bb44a56326a53da6/updatesites/${version}/features/org.testng.eclipse_${version}.jar";
      hash = "sha256-JahgneGUJN4jVxgXdkhhj5/TENXKXG635UO9Q7Vnnws=";
    };

    srcPlugin = fetchurl {
      url = "https://raw.githubusercontent.com/testng-team/testng-eclipse-update-site/0eb404d0c65dc0ef25b19145bb44a56326a53da6/updatesites/${version}/plugins/org.testng.eclipse_${version}.jar";
      hash = "sha256-DTE60G+1ZnBT0i6FHuYDQlzwxhwAeXbHN3hgkYbhn8g=";
    };

    meta = {
      homepage = "https://testng.org/doc/";
      description = "Eclipse plugin for the TestNG testing framework";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  };

  vrapper = buildEclipseUpdateSite rec {
    pname = "vrapper";
    version = "0.72.0";
    owner = "vrapper";
    repo = "vrapper";
    date = "20170311";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/${owner}/${repo}/releases/download/${version}/vrapper_${version}_${date}.zip";
      hash = "sha256-V3Y2poZ5+nFkT3MOtVAFgqne4gzAu85CEPikOo3L0Vs=";
    };

    meta = {
      homepage = "https://github.com/vrapper/vrapper";
      description = "Wrapper to provide a Vim-like input scheme for moving around and editing text";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.gpl3;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.stumoss ];
    };
  };

  yedit = buildEclipsePlugin rec {
    pname = "yedit";
    version = "1.0.20.201509041456";

    srcFeature = fetchurl {
      url = "http://dadacoalition.org/yedit/features/org.dadacoalition.yedit.feature_${version}-RELEASE.jar";
      hash = "sha256-k1bwdhO4sG7jSQLFXC18TynFYB4vS4lyy5S/FPw4+mY=";
    };

    srcPlugin = fetchurl {
      url = "http://dadacoalition.org/yedit/plugins/org.dadacoalition.yedit_${version}-RELEASE.jar";
      hash = "sha256-H+zUX+M4So3CvistbkRlUsUX/gynImfGB0ZNJD7h/vI=";
    };

    meta = {
      homepage = "https://github.com/oyse/yedit";
      description = "YAML editor plugin for Eclipse";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.epl10;
      platforms = lib.platforms.all;
    };
  };

  zest = buildEclipseUpdateSite rec {
    pname = "zest";
    version = "3.9.101";

    src = fetchurl {
      url = "http://archive.eclipse.org/tools/gef/downloads/drops/${version}/R201408150207/GEF-${pname}-${version}.zip";
      hash = "sha256-9WiMh4Tb6biaVY3G68+JnGf+XERVXn3QuExmVtmxTAc=";
    };

    meta = {
      homepage = "https://www.eclipse.org/gef/zest/";
      description = "Eclipse Visualization Toolkit";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.romildo ];
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  # Added 2025-11-16
  bytecode-outline = throw "eclipses.plugins.bytecode-outline has been removed due to being removed upstream.";
  ivyde = throw "eclipses.plugins.ivyde has been removed due to being archived upstream.";
  ivyderv = throw "eclipses.plugins.inyderv has been removed due to being archived upstream.";
  ivy = throw "eclipses.plugins.ivy has been removed due to being archived upstream.";
  ivyant = throw "eclipses.plugins.ivyant has been removed due to being archived upstream.";
  scala = throw "eclipses.plugins.scala has been removed due to being deprecated upstream.";
}
