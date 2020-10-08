{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, gtk2, libXtst, jdk, jdk8, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage
}:

assert stdenv ? glibc;

# https://download.eclipse.org/eclipse/downloads/ is the main place to
# find the downloads needed for new versions

let
  platform_major = "4";
  platform_minor = "16";
  year = "2020";
  month = "06";
  timestamp = "${year}${month}040540";
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
        sha512 = "0vfxzsvfv9zmd0ckrdpziijzskh13g8kgk8ibkwmhmqmj14a3visk6yvn5q2s0knkswl1zy9arinw0mxvqh72dfj63vwc01vhp06lyr";
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "29nr1x3fgdw5ygrppfma6yi1iaqvad24jyb58sag735z1nz4ymajcwakg52mlv3s19d4w8cxpskh1r459mwz7j769qplymspqifvlkd";
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "2pm4xam0jn9x34k1hr5rn67fpvc6snlkpcfn4bzdcf2xjv9f3dr2039mkcrhri5nv2bj6fkbai6aga6fmmrb3na33b7ir7sqlqqn61b";
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
        sha512 = "195c07yabmi2a42qxfmpbv6ychpj15bbpgyp40s1pcdb3p875vcqjinq9dqy2sixzwjhfdrggpvwihav87rkih9arzmk2s4cm31mjqd";
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "3n8jllgxarrxgz16n7zb4bgaqxk0m9frcxrgdxvy25ar2iw8js4q4ir3cc20y4ri3ii74rf3jy6n4ndhm57miwqh4p2wqzhfjlinirb";
      };
  };

  ### Eclipse Committers

  eclipse-committers = buildEclipse {
    name = "eclipse-committers-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Eclipse Committers and Eclipse Platform Plugin Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-committers-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "1l0gc7srpvn3r0yrbrp1pjv1a3n1y7q5fqww5fmzyw1d6j3hjkqj74c9bff16579cpf7z6d4wmj6kr7z89p0ignrx319gc8p0hivi1y";
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
          with stdenv.lib;
            filter (x: x ? isEclipsePlugin) (closePropagation plugins);
      };

      # Prepare the JVM arguments to add to the ini file. We here also
      # add the property indicating the plugin directory.
      dropinPropName = "org.eclipse.equinox.p2.reconciler.dropins.directory";
      dropinProp = "-D${dropinPropName}=${pluginEnv}/eclipse/dropins";
      jvmArgsText = stdenv.lib.concatStringsSep "\n" (jvmArgs ++ [dropinProp]);

      # Base the derivation name on the name of the underlying
      # Eclipse.
      name = (stdenv.lib.meta.appendToName "with-plugins" eclipse).name;
    in
      runCommand name { buildInputs = [ makeWrapper ]; } ''
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
