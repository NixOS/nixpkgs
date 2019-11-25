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
  platform_minor = "13";
  year = "2019";
  month = "09";
  timestamp = "201909161045";

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
        sha512 = "0s9wvxd1bahlcdw7l6cyfi59p78j6gym3a3mn1z6dm6swxgyb2wjjl7hx8bkg0zs8x31bwllpdq22y2vcm6j57h40v53l3xkhy73m8v";
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "09nc7ipv67h0gr7lkxsbxrgj9gn48348asn03ylcvflyrcxghqs8n11a75rwvdj98igdzpw922saicx5lqq5g2flfqiga97lwwhfiz5";
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        sha512 = "2c40wwrc2ip32n0m5cs8ds0g7cs7018acw8gjkd23msa4pr9x9511c3dj6rbnn1hwzf9yjq6vnjmib5qarxd3vly76jwxhf867l1f7v";
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
        sha512 = "2vm646d1crzzzysll3p5pjfljfjzxx4qd37dqcp6xjm91zg8iskli688h0lgla0rmbwz5kj509jp22m4rxkp3cbgd006dd0jr3icdls";
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        sha512 = "3zyxqd8iwrfgjjg91dfi4bda61rd2717hy53swmbygi48zaaam70swx997yp5qzxwjp3macdslfk6sqhq2qlcdwcdl6dmkry018jh7b";
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
