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

  eclipse-cpp = eclipse-cpp-47; # always point to latest

  eclipse-cpp-47 = buildEclipse {
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

  eclipse-cpp-37 = buildEclipse {
    name = "eclipse-cpp-3.7";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk-x86_64.tar.gz;
          sha256 = "14ppc9g9igzvj1pq7jl01vwhzb66nmzbl9wsdl1sf3xnwa9wnqk3";
        }
      else
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk.tar.gz;
          sha256 = "1cvg1vgyazrkinwzlvlf0dpl197p4784752srqybqylyj5psdi3b";
        };
  };
  eclipse_cpp_37 = eclipse-cpp-37; # backward compatibility, added 2016-01-30

  ### Eclipse Modeling

  eclipse-modeling = eclipse-modeling-47; # always point to latest

  eclipse-modeling-47 = buildEclipse {
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

  eclipse-modeling-36 = buildEclipse {
    name = "eclipse-modeling-3.6.2";
    description = "Eclipse Modeling Tools (includes Incubating components)";
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk-x86_64.tar.gz;
          sha1 = "e96f5f006298f68476f4a15a2be8589158d5cc61";
        }
      else
        fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk.tar.gz;
          sha1 = "696377895bb26445de39d82a916b7e69edb1d939";
        };
  };
  eclipse_modeling_36 = eclipse-modeling-36; # backward compatibility, added 2016-01-30

  ### Eclipse Platform

  eclipse-platform = eclipse-platform-48; # always point to latest

  eclipse-platform-46 = buildEclipse {
    name = "eclipse-platform-4.6.2";
    description = "Eclipse Platform Neon 2";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.2-201611241400/eclipse-platform-4.6.2-linux-gtk-x86_64.tar.gz;
          sha256 = "1fmpirjkp210angyfz3nr5jp58snjy6784zkkbmdxkiyg9kg2wqq";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.2-201611241400/eclipse-platform-4.6.2-linux-gtk.tar.gz;
          sha256 = "0274g6ypiqsqkch10868ygbm6avc5pa57saz9wd196kdivl1bdpm";
        };
    };
  };

  eclipse-platform-47 = buildEclipse {
    name = "eclipse-platform-4.7.3a";
    description = "Eclipse Platform Oxygen";
    sources = {
      "x86_64-linux" = fetchurl {
        url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.7.3a-201803300640/eclipse-platform-4.7.3a-linux-gtk-x86_64.tar.gz;
          sha512 = "caf86cd6efaf66258c75434f1adf552587a7395d57dba4cfd20f86196308cf942866d931f4b352f9d39a6fbf14444fcd2167e6bfd146a28c96c229bb9988156a";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.7.3a-201803300640/eclipse-platform-4.7.3a-linux-gtk.tar.gz;
          sha512 = "c633da467774e4ab40f8d51d07b8e7d8403f26f23365c3c3ceeaeec1039b8c23c7508cee1f786bf52db64c7b84e0f91cb31a2848a74ac8271f8504934407bd5c";
        };
    };
  };

  eclipse-platform-48 = buildEclipse {
    name = "eclipse-platform-4.8";
    description = "Eclipse Platform Photon";
    sources = {
      "x86_64-linux" = fetchurl {
        url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.8-201806110500/eclipse-platform-4.8-linux-gtk-x86_64.tar.gz;
          sha512 = "ccce2b954938479e42ef3f9b78f74b24ae4cae7499546fa4f9a55ec1849e1acfd06315d4529b11474a8b3d1142c9409c581edfa571baaf1342ab062f02467af2";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.8-201806110500/eclipse-platform-4.8-linux-gtk.tar.gz;
          sha512 = "f5f407727e22b848931cf38f71b1a0c30a9778aa227c3df137dcceec2fba2ecc309cbfa8b4a660b814d2edb60f65110381497b4325781cab4d6402784139e32b";
        };
    };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk = eclipse-scala-sdk-441; # always point to latest

  eclipse-scala-sdk-441 = buildEclipse {
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

  eclipse-sdk = eclipse-sdk-48; # always point to latest

  eclipse-sdk-46 = buildEclipse {
    name = "eclipse-sdk-4.6.2";
    description = "Eclipse Neon 2 Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.2-201611241400/eclipse-SDK-4.6.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0g3nk1gcz178j8xk6nblkfsaysm8gq8101383fx60x6w25rdfgjb";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.6.2-201611241400/eclipse-SDK-4.6.2-linux-gtk.tar.gz;
          sha256 = "09wlkcxs5h3j8habqxgr4all99vkgmyixc0vr9dj3qs0kl85k5mz";
        };
    };
  };

  eclipse-sdk-47 = buildEclipse {
    name = "eclipse-sdk-4.7.3a";
    description = "Eclipse Oxygen Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.7.3a-201803300640/eclipse-SDK-4.7.3a-linux-gtk-x86_64.tar.gz;
          sha512 = "d77e42aca16d26526cef32e363d038258bb8a4616d9dbe6e76dd3656dc2217369436390a82555bde4566bbbdb631813bbaca08602f7bb885cb30e8a26a14873f";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.7.3a-201803300640/eclipse-SDK-4.7.3a-linux-gtk.tar.gz;
          sha512 = "b0b936fd4142ae86ec5c30535cd5e4caf6fe313d814ae5b16f300635e4163a79b748b1eee11792a135114f2265678a74821ec80c2bfd69872769b6d0ccbcde3a";
        };
    };
  };

  eclipse-sdk-48 = buildEclipse {
    name = "eclipse-sdk-4.8";
    description = "Eclipse Photon Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.8-201806110500/eclipse-SDK-4.8-linux-gtk-x86_64.tar.gz;
          sha512 = "357ea9e7f426c68ced693f1c7b76eae23f9e3c7893de1f12d17994ec17b447896b5daa7292d5fbf6d9c4e5b7fd637ca5b2a6ba8ce40a2a7c2fe06f2124d31b75";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.8-201806110500/eclipse-SDK-4.8-linux-gtk.tar.gz;
          sha512 = "c7cae7baa3978d48477090bb9941e85b4c7484021ece9c5c77a7e859e57e5c1f13556262f92b561cfb11f828b934bad7a6018be7b8fd9454e3991e8d5cae9917";
        };
    };
  };

  eclipse-sdk-37 = buildEclipse {
    name = "eclipse-sdk-3.7";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0nf4nv7awhp1k8b1hjb7chpjyjrqnyszsjbc4dlk9phpjv3j4wg5";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk.tar.gz;
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
