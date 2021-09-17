{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, gtk2, libXtst, jdk, jdk8, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage
}:

assert stdenv ? glibc;

# https://download.eclipse.org/eclipse/downloads/ is the main place to
# find the downloads needed for new versions
#
# to test:
# $ for e in cpp modeling platform sdk java jee committers rcp; do nix build -f default.nix pkgs.eclipses.eclipse-${e} -o eclipse-${e}; done

let
  platform_major = "4";
  platform_minor = "20";
  year = "2021";
  month = "06";
  timestamp = "${year}${month}111600";
  gtk = gtk3;
in rec {

  buildEclipse = callPackage ./build-eclipse.nix {
    inherit stdenv makeDesktopItem freetype fontconfig libX11 libXrender zlib
            jdk glib gtk libXtst gsettings-desktop-schemas webkitgtk
            makeWrapper;
  };

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "3ggqiwa1nfszdqzdzw1lzs1sdikkvh2fqq10bqjxsq7xdxkis4zix8g4jcjiwlsz5gz98s61gp0k4m5rqsj0krpklxs9ijwq76khc7z";
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "38cdhy6v8jmndanvl3bimfs3pnlnl3w066fqrljy2hwki58gqmxxmbld5mphbh9y5kz9b5kiqvhx06sf0l2ywbarxy9wfhynvzb2k17";
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "2chshmn09xdq42nix0jqryhac33xc5sg7nlp2vfmz5km6q4m6mc1k7pw10jmg86zzcvcsdl9k1wkrbcsj5y2gv4cg6rddzsbx9hw3s7";
      };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk =
    buildEclipse.override { jdk = jdk8; gtk = gtk2; } {
      name = "eclipse-scala-sdk-4.7.0";
      description = "Eclipse IDE for Scala Developers";
      src =
        fetchurl {
          url = "https://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz";
          sha256  = "1n5w2a7mh9ajv6fxcas1gpgwb04pdxbr9v5dzr67gsz5bhahq4ya";
        };
  };

  ### Eclipse SDK

  eclipse-sdk = buildEclipse {
    name = "eclipse-sdk-${platform_major}.${platform_minor}";
    description = "Eclipse ${year}-${month} Classic";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-SDK-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "308sszkmp5lkva5hfb1qc5cy9b1wajas96xz5nwjl7dm2fn4saiwg3ifh71hzq59wf337hndlb2c2dp6yczsfp3mzfqmsi5a3z7dchr";
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "1wp3g85bsmv0mbpk76adsz1rzd3vbdn4y4ddv9z41bq96wi9npmybidckvwnrq57lbj8k5g8m0x0f1nhj2rv5bqbsnqjxjpknwa6is0";
      };
  };

  ### Eclipse Java EE

  eclipse-jee = buildEclipse {
    name = "eclipse-jee-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Enterprise Java and Web Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-jee-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "35v8kjpdlhbcxncqygx7c1kjqy1644c6rhrasg8gxnrhlc69zblf4nvgzf1894vd13qzpkzzxx0qll49933prnw98dqkrd0wxcx7f49";
      };
  };

  ### Eclipse Committers

  eclipse-committers = buildEclipse {
    name = "eclipse-committers-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Eclipse Committers and Eclipse Platform Plugin Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-committers-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "1jj5h69d4814j1mq6fjd47vkswq7bshbh2flgzmn8ibs0ys67x0nd2lm2ksxmvnipj4j9rw3mh9fmw8m0dzpp41c6q8xxfa93c7pqyg";
      };
  };

  ### Eclipse IDE for RCP and RAP Developers

  eclipse-rcp = buildEclipse {
    name = "eclipse-rcp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for RCP and RAP Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-rcp-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "19fr63bdifxqp6imgb4d7v5dnkn9i0n2wmr08xzb0ph425ib936jiw84c2nwnsfnljh0yfj1r3wd36y2nn52fsj6ginl8plc6pi5416";
      };
  };

  ### Environments

  # Function that assembles a complete Eclipse environment from an
  # Eclipse package and list of Eclipse plugins.
  eclipseWithPlugins = { eclipse, plugins ? [], jvmArgs ? [] }:
    let
      # Gather up the desired plugins.
      pluginEnv = buildEnv {
        name = "eclipse-plugins";
        paths =
          with lib;
            filter (x: x ? isEclipsePlugin) (closePropagation plugins);
      };

      # Prepare the JVM arguments to add to the ini file. We here also
      # add the property indicating the plugin directory.
      dropinPropName = "org.eclipse.equinox.p2.reconciler.dropins.directory";
      dropinProp = "-D${dropinPropName}=${pluginEnv}/eclipse/dropins";
      jvmArgsText = lib.concatStringsSep "\n" (jvmArgs ++ [dropinProp]);

      # Base the derivation name on the name of the underlying
      # Eclipse.
      name = (lib.meta.appendToName "with-plugins" eclipse).name;
    in
      runCommand name { nativeBuildInputs = [ makeWrapper ]; } ''
        mkdir -p $out/bin $out/etc

        # Prepare an eclipse.ini with the plugin directory.
        cat ${eclipse}/eclipse/eclipse.ini - > $out/etc/eclipse.ini <<EOF
        ${jvmArgsText}
        EOF

        makeWrapper ${eclipse}/bin/eclipse $out/bin/eclipse \
          --add-flags "--launcher.ini $out/etc/eclipse.ini"

        ln -s ${eclipse}/share $out/
      '';

  ### Plugins

  plugins = callPackage ./plugins.nix { };

}
