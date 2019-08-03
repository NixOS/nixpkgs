{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, libXtst, jdk, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage
}:

assert stdenv ? glibc;

# http://download.eclipse.org/eclipse/downloads/ is the main place to
# find the downloads needed for new versions

let
  platform_major = "4";
  platform_minor = "12";
  year = "2019";
  month = "06";
  timestamp = "201906051800";

in rec {

  buildEclipse = import ./build-eclipse.nix {
    inherit stdenv makeDesktopItem freetype fontconfig libX11 libXrender zlib
            jdk glib gtk3 libXtst gsettings-desktop-schemas webkitgtk
            makeWrapper;
  };

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for C/C++ Developers, Oxygen release";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "3mfljabrwbwq256vvsp9qjb96hzlbpwgnb3wz806pbyh0ibfq6s1hn8kh5aaa2da5821v0ykcxa12jagj7naqp4g91jqxp1wb1ygz2q";
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "18p6xz6rq4w6j39b2k9kjpz8s1nljfq44g2cmvxqjgjfkq8lk4ij73ssyv1raly4wkm7r22ixacswdjmyj942k5vpv9y11i91hp1scv";
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "0qiyk95qhdqcfgg5hgc7pcpbpjy9jnx7l3vb7s4cgijdz2xz0n5psh11lpj3whk2amh4iwkyx7kn8fxdq7lm03rlgx67cbk7p8my16m";
      };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk = buildEclipse {
    name = "eclipse-scala-sdk-4.4.1";
    description = "Eclipse IDE for Scala Developers";
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl { # tested
          url = https://downloads.typesafe.com/scalaide-pack/4.4.1-vfinal-luna-211-20160504/scala-SDK-4.4.1-vfinal-2.11-linux.gtk.x86_64.tar.gz;
          sha256  = "4c2d1ac68384e12a11a851cf0fc7757aea087eba69329b21d539382a65340d27";
        }
      else
        fetchurl { # untested
          url = https://downloads.typesafe.com/scalaide-pack/4.4.1-vfinal-luna-211-20160504/scala-SDK-4.4.1-vfinal-2.11-linux.gtk.x86.tar.gz;
          sha256 = "35383cb09567187e14a30c15de9fd9aa0eef99e4bbb342396ce3acd11fb5cbac";
        };
  };

  ### Eclipse SDK

  eclipse-sdk = buildEclipse {
    name = "eclipse-sdk-${platform_major}.${platform_minor}";
    description = "Eclipse ${year}-${month} Classic";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-SDK-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "3bbc8d66ms7nhg6f8gb0bnzjqz26wixpipn4n9qf0azcplrv2j91z8hjw1fx39dx4pqnsf442bkgab4qqhkpks7qq54110l01q6gvy9";
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "20qs1aagh4drsycvar3x42zy422zl34yg1p3vhxbqfbf7v3z1d3cxs9ah61x4bdxx9bkfwchasqp1wr15nflch9g0i50bdki3cgng1d";
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
