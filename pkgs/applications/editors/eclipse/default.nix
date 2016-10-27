{ stdenv, lib, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, libXtst, jdk
, webkitgtk2 ? null  # for internal web browser
, buildEnv, writeText, runCommand
, callPackage
}:

assert stdenv ? glibc;

rec {

  buildEclipse = callPackage ./build-eclipse.nix { };

  ### Eclipse CPP

  eclipse-cpp-46 = buildEclipse {
    name = "eclipse-cpp-4.6.0";
    description = "Eclipse IDE for C/C++ Developers, Neon release";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/neon/R/eclipse-cpp-neon-R-linux-gtk-x86_64.tar.gz;
          sha256 = "09fqsgvbjfdqvn7z03crkii34z4bsb34y272q68ib8741bxk0i6m";
        }
      else if stdenv.system == "i686-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/neon/R/eclipse-cpp-neon-R-linux-gtk.tar.gz;
          sha256 = "0a12qmqq22v7sbmwn1hjv1zcrkmp64bf0ajmdjljhs9ac79mxn5h";
        }
      else throw "Unsupported system: ${stdenv.system}";
  };

  eclipse-cpp-37 = buildEclipse {
    name = "eclipse-cpp-3.7";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk-x86_64.tar.gz;
          sha256 = "14ppc9g9igzvj1pq7jl01vwhzb66nmzbl9wsdl1sf3xnwa9wnqk3";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk.tar.gz;
          sha256 = "1cvg1vgyazrkinwzlvlf0dpl197p4784752srqybqylyj5psdi3b";
        };
  };
  eclipse_cpp_37 = eclipse-cpp-37; # backward compatibility, added 2016-01-30

  ### Eclipse Modeling

  eclipse-modeling-46 = buildEclipse {
    name = "eclipse-modeling-4.6";
    description = "Eclipse Modeling Tools";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/neon/1a/eclipse-modeling-neon-1a-linux-gtk-x86_64.tar.gz;
          sha1 = "3695fd049c4cca2d235f424557e19877795a8183";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/neon/1a/eclipse-modeling-neon-1a-linux-gtk.tar.gz;
          sha1 = "fa0694a0b44e8e9c2301417f84dba45cf9ac6e61";
        };
  };

  eclipse-modeling-36 = buildEclipse {
    name = "eclipse-modeling-3.6.2";
    description = "Eclipse Modeling Tools (includes Incubating components)";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk-x86_64.tar.gz;
          sha1 = "e96f5f006298f68476f4a15a2be8589158d5cc61";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk.tar.gz;
          sha1 = "696377895bb26445de39d82a916b7e69edb1d939";
        };
  };
  eclipse_modeling_36 = eclipse-modeling-36; # backward compatibility, added 2016-01-30

  ### Eclipse Platform

  eclipse-platform = eclipse-platform-46;

  eclipse-platform-46 = buildEclipse {
    name = "eclipse-platform-4.6.1";
    description = "Eclipse platform";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.1-201609071200/eclipse-SDK-4.6.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1mr7sj4whz23iwz5j6mbqd80a39177qv0r7b6cip7dji4n2agl8j";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.1-201609071200/eclipse-SDK-4.6.1-linux-gtk.tar.gz;
          sha256 = "0kgj0zpgzwx90q13c4mr8swf63azd56532ycxgq2rbs0d1qbl87j";
        };
    };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk-441 = buildEclipse {
    name = "eclipse-scala-sdk-4.4.1";
    description = "Eclipse IDE for Scala Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl { # tested
          url = http://downloads.typesafe.com/scalaide-pack/4.4.1-vfinal-luna-211-20160504/scala-SDK-4.4.1-vfinal-2.11-linux.gtk.x86_64.tar.gz;
          sha256  = "4c2d1ac68384e12a11a851cf0fc7757aea087eba69329b21d539382a65340d27";
        }
      else
        fetchurl { # untested
          url = http://downloads.typesafe.com/scalaide-pack/4.4.1-vfinal-luna-211-20160504/scala-SDK-4.4.1-vfinal-2.11-linux.gtk.x86.tar.gz;
          sha256 = "35383cb09567187e14a30c15de9fd9aa0eef99e4bbb342396ce3acd11fb5cbac";
        };
  };

  ### Eclipse SDK

  eclipse-sdk-46 = buildEclipse {
    name = "eclipse-sdk-4.6.1";
    description = "Eclipse Neon Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.1-201609071200/eclipse-SDK-4.6.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1mr7sj4whz23iwz5j6mbqd80a39177qv0r7b6cip7dji4n2agl8j";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.1-201609071200/eclipse-SDK-4.6.1-linux-gtk.tar.gz;
          sha256 = "0kgj0zpgzwx90q13c4mr8swf63azd56532ycxgq2rbs0d1qbl87j";
        };
    };
  };

  eclipse-sdk-37 = buildEclipse {
    name = "eclipse-sdk-3.7";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0nf4nv7awhp1k8b1hjb7chpjyjrqnyszsjbc4dlk9phpjv3j4wg5";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk.tar.gz;
          sha256 = "1isn7i45l9kyn2yx6vm88jl1gnxph8ynank0aaa218cg8kdygk7j";
        };
    };
  };
  eclipse_sdk_37 = eclipse-sdk-37; # backward compatibility, added 2016-01-30

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
