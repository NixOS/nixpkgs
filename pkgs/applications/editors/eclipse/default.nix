{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jdk
, webkitgtk2 ? null  # for internal web browser
, buildEnv, writeText, runCommand
, callPackage
} @ args:

assert stdenv ? glibc;

rec {

  buildEclipse = import ./build-eclipse.nix args;

  eclipse-sdk-35 = buildEclipse {
    name = "eclipse-sdk-3.5.2";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk-x86_64.tar.gz;
          md5 = "54e2ce0660b2b1b0eb4267acf70ea66d";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk.tar.gz;
          md5 = "bde55a2354dc224cf5f26e5320e72dac";
        };
  };
  eclipse_sdk_35 = eclipse-sdk-35; # backward compatibility, added 2016-01-30

  eclipse-sdk-36 = buildEclipse {
    name = "eclipse-sdk-3.6.2";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0dfcfadcd6337c897fbfd5b292de481931dfce12d43289ecb93691fd27dd47f4";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk.tar.gz;
          sha256 = "1bh8ykliqr8wbciv13vpiy50rvm7yszk7y8dslr796dbwhi5b1cj";
        };
  };
  eclipse_sdk_36 = eclipse-sdk-36; # backward compatibility, added 2016-01-30

  eclipse-scala-sdk-40 = buildEclipse {
    name = "eclipse-scala-sdk-4.0.0";
    description = "Eclipse IDE for Scala Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl { # tested
          url = http://downloads.typesafe.com/scalaide-pack/4.0.0.vfinal-luna-211-20150305/scala-SDK-4.0.0-vfinal-2.11-linux.gtk.x86_64.tar.gz;
          sha256  = "b65c5e8160e72c8389537e9e427138e6daa2065f9df3a943a86e40dd1543dd83";
        }
      else
        fetchurl { # untested
          url = http://downloads.typesafe.com/scalaide-pack/4.0.0.vfinal-luna-211-20150305/scala-SDK-4.0.0-vfinal-2.11-linux.gtk.x86.tar.gz;
          sha256 = "f422aea5903c97d212264a5a43c6ebc638aecbd4ce5e6078d92618725bc5d31e";
        };
  };
  eclipse_scala_sdk_40 = eclipse-scala-sdk-40; # backward compatibility, added 2016-01-30

  eclipse-cpp-36 = buildEclipse {
    name = "eclipse-cpp-3.6.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz;
          sha1 = "6f914e11fa15a900c46825e4aa8299afd76e7e65";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk.tar.gz;
          sha1 = "1156e4bc0253ae3a3a4e54839e4944dc64d3108f";
        };
  };
  eclipse_cpp_36 = eclipse-cpp-36; # backward compatibility, added 2016-01-30

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

  eclipse-cpp-42 = buildEclipse {
    name = "eclipse-cpp-4.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/juno/SR2/eclipse-cpp-juno-SR2-linux-gtk-x86_64.tar.gz;
          sha256 = "1qq04926pf7v9sf3s0z53zvlbl1j0rmmjmbmhqi49473fnjikh7y";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/juno/SR2/eclipse-cpp-juno-SR2-linux-gtk.tar.gz;
          sha256 = "1a4s9qlhfpfpdhvffyglnfdr3dq5r2ywcxqywhqi95yhq5nmsgyk";
        };
  };
  eclipse_cpp_42 = eclipse-cpp-42; # backward compatibility, added 2016-01-30

  eclipse-cpp-43 = buildEclipse {
    name = "eclipse-cpp-4.3.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/kepler/SR2/eclipse-cpp-kepler-SR2-linux-gtk-x86_64.tar.gz;
          sha256 = "16zhjm6bx78263b1clg75kfiliahkhwg0k116vp9fj039nlpc30l";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/kepler/SR2/eclipse-cpp-kepler-SR2-linux-gtk.tar.gz;
          sha256 = "0d6jlj7hwz8blx6csrlyi2h2prql0wckbh7ihwjmgclwpcpj84g6";
        };
  };
  eclipse_cpp_43 = eclipse-cpp-43; # backward compatibility, added 2016-01-30
  
  eclipse-cpp-44 = buildEclipse {
    name = "eclipse-cpp-4.4.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz;
          sha256 = "1vxwj7yihgipvrb3gksmddqkarzazpwk3mh1mjnw0i5xz2y32ba4";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk.tar.gz;
          sha256 = "1yn7yzzx8izc199c8w4f7vrc0b08idyq0dn113i8123b0mxw5lkp";
        };
  };
  eclipse_cpp_44 = eclipse-cpp-44; # backward compatibility, added 2016-01-30

  eclipse-cpp-45 = buildEclipse {
    name = "eclipse-cpp-4.5.1";
    description = "Eclipse IDE for C/C++ Developers, Mars release";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/mars/1/eclipse-cpp-mars-1-linux-gtk-x86_64.tar.gz;
          sha256 = "1j6rsgr44kya2v7y34ifscajqk7lnq1w9m9fx4i0qgby84sy4xj7";
        }
      else if stdenv.system == "i686-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/mars/1/eclipse-cpp-mars-1-linux-gtk.tar.gz;
          sha256 = "0qsbvjkq0ssxbnafh4gs8pfclynqis3nf7xlxx4w3k20jcjx7sr2";
        }
      else throw "Unsupported system: ${stdenv.system}";
  };
  eclipse_cpp_45 = eclipse-cpp-45; # backward compatibility, added 2016-01-30

  eclipse-sdk-421 = buildEclipse {
    name = "eclipse-sdk-4.2.1";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1mlyy90lk08lb2971ynglgi3nqvqfq1k70md2kb39jk160wd1xrk";
        }
      else
        fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk.tar.gz;
          sha256 = "1av6qm9wkbyk123qqf38f0jq4jv2bj9wp6fmpnl55zg6qr463c1w";
        };
    };
  eclipse_sdk_421 = eclipse-sdk-421; # backward compatibility, added 2016-01-30

  eclipse-sdk-422 = buildEclipse {
    name = "eclipse-sdk-4.2.2";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.2.2-201302041200/eclipse-SDK-4.2.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0ysa6ymk4h3k1vn59dc909iy197kmx132671kbzfwbim87jmgnqb";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.2.2-201302041200/eclipse-SDK-4.2.2-linux-gtk.tar.gz;
          sha256 = "038yibbrcia38wi72qrdl03g7l35mpvl5nxdfdnvpqxrkfffb826";
        };
    };
  };
  eclipse_sdk_422 = eclipse-sdk-422; # backward compatibility, added 2016-01-30

  eclipse-sdk-431 = buildEclipse {
    name = "eclipse-sdk-4.3.1";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.3.1-201309111000/eclipse-SDK-4.3.1-linux-gtk-x86_64.tar.gz;
          sha256 = "0ncm56ylwxw9z8rk8ccgva68c2yr9yrf1kcr1zkgw6p87xh1yczd";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.3.1-201309111000/eclipse-SDK-4.3.1-linux-gtk.tar.gz;
          sha256 = "1zxsh838khny7mvl01h28xna6xdh01yi4mvls28zj22v0340lgsg";
        };
    };
  };
  eclipse_sdk_431 = eclipse-sdk-431; # backward compatibility, added 2016-01-30

  eclipse-sdk-44 = buildEclipse {
    name = "eclipse-sdk-4.4";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.4-201406061215/eclipse-SDK-4.4-linux-gtk-x86_64.tar.gz;
          sha256 = "14hdkijsjq0hhzi9ijpwjjkhz7wm0pry86l3dniy5snlh3l5bsb2";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.4-201406061215/eclipse-SDK-4.4-linux-gtk.tar.gz;
          sha256 = "0hjc4zrsmik6vff851p0a4ydnx99840j2xrx8348kk6h0af8vx6z";
        };
    };
  };
  eclipse_sdk_44 = eclipse-sdk-44; # backward compatibility, added 2016-01-30

  eclipse-sdk-442 = buildEclipse {
    name = "eclipse-sdk-4.4.2";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.4.2-201502041700/eclipse-SDK-4.4.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0g00alsixfaakmn4khr0m9fxvkrbhbg6qqfa27xr6a9np6gzg98l";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.4.2-201502041700/eclipse-SDK-4.4.2-linux-gtk.tar.gz;
          sha256 = "1hacyjjwhhxi7r3xyhpqgjqpd5r0irw9bfkalz5s5l6shb0lq4i7";
        };
    };
  };
  eclipse_sdk_442 = eclipse-sdk-442; # backward compatibility, added 2016-01-30

  eclipse-sdk-45 = buildEclipse {
    name = "eclipse-sdk-4.5";
    description = "Eclipse Mars Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5-201506032000/eclipse-SDK-4.5-linux-gtk-x86_64.tar.gz;
          sha256 = "0vfql4gh263ms8bg7sgn05gnjajplx304cn3nr03jlacgr3pkarf";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5-201506032000/eclipse-SDK-4.5-linux-gtk.tar.gz;
          sha256 = "0xv66l6hdlvxpswcqrsh398wg6xhy30f833dr7jvvz45s5437hm3";
        };
    };
  };
  eclipse_sdk_45 = eclipse-sdk-45; # backward compatibility, added 2016-01-30

  eclipse-sdk-451 = buildEclipse {
    name = "eclipse-sdk-4.5.1";
    description = "Eclipse Mars Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.1-201509040015/eclipse-SDK-4.5.1-linux-gtk-x86_64.tar.gz;
          sha256 = "b56503ab4b86f54e1cdc93084ef8c32fb1eaabc6f6dad9ef636153b14c928e02";
        };
      "i686-linux" = fetchurl {
          url = http://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.1-201509040015/eclipse-SDK-4.5.1-linux-gtk.tar.gz;
          sha256 = "f2e41da52e138276f8f121fd4d57c3f98839817836b56f8424e99b63c9b1b025";
        };
    };
  };
  eclipse_sdk_451 = eclipse-sdk-451; # backward compatibility, added 2016-01-30

  eclipse-platform = eclipse-platform-452;

  eclipse-platform-45 = buildEclipse {
    name = "eclipse-platform-4.5";
    description = "Eclipse platform";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5-201506032000/eclipse-platform-4.5-linux-gtk-x86_64.tar.gz;
          sha256 = "1510j41yr86pbzwf48kjjdd46nkpkh8zwn0hna0cqvsw1gk2vqcg";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5-201506032000/eclipse-platform-4.5-linux-gtk.tar.gz;
          sha256 = "1f97jd3qbi3830y3djk8bhwzd9whsq8gzfdk996chxc55prn0qbd";
        };
    };
  };

  eclipse-platform-451 = buildEclipse {
    name = "eclipse-platform-4.5.1";
    description = "Eclipse platform";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.1-201509040015/eclipse-platform-4.5.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1m7bzyi20yss6cz74d7hvhxj1cddcpgzxjia5wcjycsvq33kkny0";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.1-201509040015/eclipse-platform-4.5.1-linux-gtk.tar.gz;
          sha256 = "17x8w4k0rba0c0v9ghxdl0zqfadla5c1aakfd5k0q9q3x3qi6rxp";
        };
    };
  };

  eclipse-platform-452 = buildEclipse {
    name = "eclipse-platform-4.5.2";
    description = "Eclipse platform";
    sources = {
      "x86_64-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.2-201602121500/eclipse-SDK-4.5.2-linux-gtk-x86_64.tar.gz;
          sha256 = "13dsd5f5i39wd0sr2bgp57hd2msn8g2dnmw5j8hfwif22c62py47";
        };
      "i686-linux" = fetchurl {
          url = https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops4/R-4.5.2-201602121500/eclipse-SDK-4.5.2-linux-gtk.tar.gz;
          sha256 = "00jsmbrl4xhpbgd8hyxijgzqdic700kd3yw2qwgl0cs3ncvybxvq";
        };
    };
  };

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

  plugins = callPackage ./plugins.nix { };

}
