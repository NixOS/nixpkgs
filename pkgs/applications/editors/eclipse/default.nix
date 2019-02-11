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

rec {

  buildEclipse = import ./build-eclipse.nix {
    inherit stdenv makeDesktopItem freetype fontconfig libX11 libXrender zlib
            jdk glib gtk3 libXtst gsettings-desktop-schemas webkitgtk
            makeWrapper;
  };

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-4.7.0";
    description = "Eclipse IDE for C/C++ Developers, Oxygen release";
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/oxygen/R/eclipse-cpp-oxygen-R-linux-gtk-x86_64.tar.gz;
          sha512 = "813c791e739d7d0e2ab242a5bacadca135bbeee20ef97aa830353cd90f63fa6e9c89cfcc6aadf635c742befe035bd6e3f15103013f63c419f6144e86ebde3ed1";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/oxygen/R/eclipse-cpp-oxygen-R-linux-gtk.tar.gz;
          sha512 = "2b50f4a00306a89cda1aaaa606e62285cacbf93464a9dd3f3319dca3e2c578b802e685de6f78e5e617d269e21271188effe73d41f491a6de946e28795d82db8a";
        }
      else throw "Unsupported system: ${stdenv.hostPlatform.system}";
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-4.7";
    description = "Eclipse Modeling Tools";
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/oxygen/R/eclipse-modeling-oxygen-R-linux-gtk-x86_64.tar.gz;
          sha512 = "3b9a7ad4b5d6b77fbdd64e8d323e0adb6c2904763ad042b374b4d87cef8607408cb407e395870fc755d58c0c800e20818adcf456ebe193d76cede16c5fe12271";
        }
      else
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/oxygen/R/eclipse-modeling-oxygen-R-linux-gtk.tar.gz;
          sha512 = "b8597c1dec117e69c72a5e1a53e09b1f81a7c9de86ed7e71a9d007664603202df301745f186ded02b2e76410345863e80a2ba40867d6848e5375601289999206";
        };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-4.9";
    description = "Eclipse Platform 2018-09";
    sources = {
      "x86_64-linux" = fetchurl {
        url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-platform-4.9-linux-gtk-x86_64.tar.gz;
          sha512 = "875714bb411145c917fccedf2f7c4fd2757640b2debf4a18f775604233abd6f0da893b350cc03da44413d7ec6fae3f773ef08634e632058e4b705e6cda2893eb";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-platform-4.9-linux-gtk.tar.gz;
          sha512 = "758bc0de30fa5c4b76b343ea0325611d87b6928ef5002244f2f1ba2a9fa937de89b2a94ce2c8d33d79344fd574d6e8a72c5d127fe416d785f48600e9e85fce86";
        };
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
    name = "eclipse-sdk-4.9";
    description = "Eclipse 2018-09 Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-SDK-4.9-linux-gtk-x86_64.tar.gz;
          sha512 = "5e74a0411f56b3973b7c6d8c3727392297d55ad458a814b4cc3f2f6a57dbeebc64852d1a6a958db5c3b08c620093bfb5bcc0d2c6a400f5594b82c2ef5d5fa9fb";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-SDK-4.9-linux-gtk.tar.gz;
          sha512 = "b1861bd99c8e43f1d04247226584246aa7844af5e2da820fe98a51018dbe8ff4c25dbb9fa655f56e103f95c0696f40a65dcce13430c63aa080f786738e70eb8b";
        };
    };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-4.9.0";
    description = "Eclipse IDE for Java Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/2018-09/R/eclipse-java-2018-09-linux-gtk-x86_64.tar.gz;
          sha512 = "9dac5d040cdabf779de3996de87290e352130c7e860c1d0a98772f41da828ad45f90748b68e0a8a4f8d1ebbbbe5fdfe6401b7d871b93af34103d4a81a041c6a5";
        }
      else if stdenv.system == "i686-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/2018-09/R/eclipse-java-2018-09-linux-gtk.tar.gz;
          sha512 = "24208e95b972e848d6b65ed8108d9e81584cf051397f2f43fb6269f5a625b8d7552ad77c7980a1a5653c87f06776e2926fd85607aae44e44657b4f6cc9b3e2e3";
        }
      else throw "Unsupported system: ${stdenv.system}";
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
