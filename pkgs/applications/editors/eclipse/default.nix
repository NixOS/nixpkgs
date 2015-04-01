{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre
, webkitgtk2 ? null  # for internal web browser
}:

assert stdenv ? glibc;

let

  buildEclipse =
    { name, src ? builtins.getAttr stdenv.system sources, sources ? null, description }:

    stdenv.mkDerivation rec {
      inherit name src;

      desktopItem = makeDesktopItem {
        name = "Eclipse";
        exec = "eclipse";
        icon = "eclipse";
        comment = "Integrated Development Environment";
        desktopName = "Eclipse IDE";
        genericName = "Integrated Development Environment";
        categories = "Application;Development;";
      };

      buildInputs = [ makeWrapper ];

      buildCommand = ''
        # Unpack tarball.
        mkdir -p $out
        tar xfvz $src -C $out

        # Patch binaries.
        interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
        libCairo=$out/eclipse/libcairo-swt.so
        patchelf --set-interpreter $interpreter $out/eclipse/eclipse
        [ -f $libCairo ] && patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXrender}/lib:${zlib}/lib $libCairo

        # Create wrapper script.  Pass -configuration to store
        # settings in ~/.eclipse/org.eclipse.platform_<version> rather
        # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
        productId=$(sed 's/id=//; t; d' $out/eclipse/.eclipseproduct)
        productVersion=$(sed 's/version=//; t; d' $out/eclipse/.eclipseproduct)
        
        makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
          --prefix PATH : ${jre}/bin \
          --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib${stdenv.lib.optionalString (webkitgtk2 != null) ":${webkitgtk2}/lib"} \
          --add-flags "-configuration \$HOME/.eclipse/''${productId}_$productVersion/configuration"

        # Create desktop item.
        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/* $out/share/applications
        mkdir -p $out/share/pixmaps
        ln -s $out/eclipse/icon.xpm $out/share/pixmaps/eclipse.xpm
      ''; # */

      meta = {
        homepage = http://www.eclipse.org/;
        inherit description;
      };

    };
    
in {

  eclipse_sdk_35 = buildEclipse {
    name = "eclipse-sdk-3.5.2";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk-x86_64.tar.gz;
          md5 = "54e2ce0660b2b1b0eb4267acf70ea66d";
        }
      else
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk.tar.gz;
          md5 = "bde55a2354dc224cf5f26e5320e72dac";
        };
  };

  # !!! Use mirror://eclipse/.

  eclipse_sdk_36 = buildEclipse {
    name = "eclipse-sdk-3.6.2";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0dfcfadcd6337c897fbfd5b292de481931dfce12d43289ecb93691fd27dd47f4";
        }
      else
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk.tar.gz;
          sha256 = "1bh8ykliqr8wbciv13vpiy50rvm7yszk7y8dslr796dbwhi5b1cj";
        };
  };

  eclipse_cpp_36 = buildEclipse {
    name = "eclipse-cpp-3.6.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz;
          sha1 = "6f914e11fa15a900c46825e4aa8299afd76e7e65";
        }
      else
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk.tar.gz;
          sha1 = "1156e4bc0253ae3a3a4e54839e4944dc64d3108f";
        };
  };

  eclipse_modeling_36 = buildEclipse {
    name = "eclipse-modeling-3.6.2";
    description = "Eclipse Modeling Tools (includes Incubating components)";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk-x86_64.tar.gz;
          sha1 = "e96f5f006298f68476f4a15a2be8589158d5cc61";
        }
      else
        fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-modeling-helios-SR2-incubation-linux-gtk.tar.gz;
          sha1 = "696377895bb26445de39d82a916b7e69edb1d939";
        };
  };

  eclipse_sdk_37 = buildEclipse {
    name = "eclipse-sdk-3.7";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0nf4nv7awhp1k8b1hjb7chpjyjrqnyszsjbc4dlk9phpjv3j4wg5";
        };
      "i686-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk.tar.gz;
          sha256 = "1isn7i45l9kyn2yx6vm88jl1gnxph8ynank0aaa218cg8kdygk7j";
        };
    };
  };

  eclipse_cpp_37 = buildEclipse {
    name = "eclipse-cpp-3.7";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk-x86_64.tar.gz;
          sha256 = "14ppc9g9igzvj1pq7jl01vwhzb66nmzbl9wsdl1sf3xnwa9wnqk3";
        }
      else
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/indigo/R/eclipse-cpp-indigo-incubation-linux-gtk.tar.gz;
          sha256 = "1cvg1vgyazrkinwzlvlf0dpl197p4784752srqybqylyj5psdi3b";
        };
  };

  eclipse_cpp_42 = buildEclipse {
    name = "eclipse-cpp-4.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/juno/SR2/eclipse-cpp-juno-SR2-linux-gtk-x86_64.tar.gz;
          sha256 = "1qq04926pf7v9sf3s0z53zvlbl1j0rmmjmbmhqi49473fnjikh7y";
        }
      else
        fetchurl {
          url = http://eclipse.ialto.com/technology/epp/downloads/release/juno/SR2/eclipse-cpp-juno-SR2-linux-gtk.tar.gz;
          sha256 = "1a4s9qlhfpfpdhvffyglnfdr3dq5r2ywcxqywhqi95yhq5nmsgyk";
        };
  };

  eclipse_cpp_43 = buildEclipse {
    name = "eclipse-cpp-4.3.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/kepler/SR2/eclipse-cpp-kepler-SR2-linux-gtk-x86_64.tar.gz;
          sha256 = "16zhjm6bx78263b1clg75kfiliahkhwg0k116vp9fj039nlpc30l";
        }
      else
        fetchurl {
          url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/kepler/SR2/eclipse-cpp-kepler-SR2-linux-gtk.tar.gz;
          sha256 = "0d6jlj7hwz8blx6csrlyi2h2prql0wckbh7ihwjmgclwpcpj84g6";
        };
  };
  
   eclipse_cpp_44 = buildEclipse {
    name = "eclipse-cpp-4.4";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/R/eclipse-cpp-luna-R-linux-gtk-x86_64.tar.gz;
          md5 = "b0a6ee33e8108a7ff4682ab911271b04";
        }
      else
        fetchurl {
          url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/R/eclipse-cpp-luna-R-linux-gtk.tar.gz;
          md5 = "5000f93cecf6ef9af112f0df6e8c87f3";
        };
  };


  eclipse_sdk_421 = buildEclipse {
    name = "eclipse-sdk-4.2.1";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1mlyy90lk08lb2971ynglgi3nqvqfq1k70md2kb39jk160wd1xrk";
        }
      else
        fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk.tar.gz;
          sha256 = "1av6qm9wkbyk123qqf38f0jq4jv2bj9wp6fmpnl55zg6qr463c1w";
        };
    };

  eclipse_sdk_422 = buildEclipse {
    name = "eclipse-sdk-4.2.2";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops4/R-4.2.2-201302041200/eclipse-SDK-4.2.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0ysa6ymk4h3k1vn59dc909iy197kmx132671kbzfwbim87jmgnqb";
        };
      "i686-linux" = fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops4/R-4.2.2-201302041200/eclipse-SDK-4.2.2-linux-gtk.tar.gz;
          sha256 = "038yibbrcia38wi72qrdl03g7l35mpvl5nxdfdnvpqxrkfffb826";
        };
    };
  };

  eclipse_sdk_431 = buildEclipse {
    name = "eclipse-sdk-4.3.1";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.3.1-201309111000/eclipse-SDK-4.3.1-linux-gtk-x86_64.tar.gz;
          sha256 = "0ncm56ylwxw9z8rk8ccgva68c2yr9yrf1kcr1zkgw6p87xh1yczd";
        };
      "i686-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.3.1-201309111000/eclipse-SDK-4.3.1-linux-gtk.tar.gz;
          sha256 = "1zxsh838khny7mvl01h28xna6xdh01yi4mvls28zj22v0340lgsg";
        };
    };
  };

  eclipse_sdk_44 = buildEclipse {
    name = "eclipse-sdk-4.4";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.4-201406061215/eclipse-SDK-4.4-linux-gtk-x86_64.tar.gz;
          sha256 = "14hdkijsjq0hhzi9ijpwjjkhz7wm0pry86l3dniy5snlh3l5bsb2";
        };
      "i686-linux" = fetchurl {
          url = http://archive.eclipse.org/eclipse/downloads/drops4/R-4.4-201406061215/eclipse-SDK-4.4-linux-gtk.tar.gz;
          sha256 = "0hjc4zrsmik6vff851p0a4ydnx99840j2xrx8348kk6h0af8vx6z";
        };
    };
  };

  eclipse_sdk_442 = buildEclipse {
    name = "eclipse-sdk-4.4.2";
    description = "Eclipse Classic";
    sources = {
      "x86_64-linux" = fetchurl {
          url = http://download.eclipse.org/eclipse/downloads/drops4/R-4.4.2-201502041700/eclipse-SDK-4.4.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0g00alsixfaakmn4khr0m9fxvkrbhbg6qqfa27xr6a9np6gzg98l";

        };
      "i686-linux" = fetchurl {
          url = http://download.eclipse.org/eclipse/downloads/drops4/R-4.4.2-201502041700/eclipse-SDK-4.4.2-linux-gtk.tar.gz;
          sha256 = "9f4238ce9f887a1a57bbc6c6898e43357d14a6d74f59385327813c5e82aa735d";
        };
    };
  };
}
