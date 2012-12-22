{ stdenv, fetchurl, patchelf, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre
}:

assert stdenv ? glibc;

let

  buildEclipse =
    { name, src, description }:

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

      buildInputs = [ makeWrapper patchelf ];

      buildCommand = ''
        # Unpack tarball.
        mkdir -p $out
        tar xfvz $src -C $out

        # Patch binaries.
        interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
        patchelf --set-interpreter $interpreter $out/eclipse/eclipse
        patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXrender}/lib:${zlib}/lib $out/eclipse/libcairo-swt.so

        # Create wrapper script.  Pass -configuration to store
        # settings in ~/.eclipse/org.eclipse.platform_<version> rather
        # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
        productId=$(sed 's/id=//; t; d' $out/eclipse/.eclipseproduct)
        productVersion=$(sed 's/version=//; t; d' $out/eclipse/.eclipseproduct)
        
        makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
          --prefix PATH : ${jre}/bin \
          --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib \
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
          url = http://ftp.ing.umu.se/mirror/eclipse/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk-x86_64.tar.gz;
          sha256 = "0dfcfadcd6337c897fbfd5b292de481931dfce12d43289ecb93691fd27dd47f4";
        }
      else
        fetchurl {
          url = http://ftp.ing.umu.se/mirror/eclipse/eclipse/downloads/drops/R-3.6.2-201102101200/eclipse-SDK-3.6.2-linux-gtk.tar.gz;
          sha256 = "1bh8ykliqr8wbciv13vpiy50rvm7yszk7y8dslr796dbwhi5b1cj";
        };
  };

  eclipse_cpp_36 = buildEclipse {
    name = "eclipse-cpp-3.6.2";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz;
          sha1 = "6f914e11fa15a900c46825e4aa8299afd76e7e65";
        }
      else
        fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk.tar.gz;
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
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://eclipse.ialto.com/eclipse/downloads/drops/R-3.7-201106131736/eclipse-SDK-3.7-linux-gtk-x86_64.tar.gz;
          sha256 = "00ig3ww98r8imf32sx5npm6csn5nx288gvdk6w653nijni0di16j";
        }
      else
        fetchurl {
          url = http://eclipse.ialto.com/eclipse/downloads/drops/R-3.7-201106131736/eclipse-SDK-3.7-linux-gtk.tar.gz;
          sha256 = "08rgw85cam51l98mzb39fdc3ykb369v8pap93qhknbs6a3f5dnff";
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

  eclipse_sdk_42 = buildEclipse {
    name = "eclipse-sdk-4.2";
    description = "Eclipse Classic";
    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://eclipse.ialto.com/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk-x86_64.tar.gz;
          sha256 = "1mlyy90lk08lb2971ynglgi3nqvqfq1k70md2kb39jk160wd1xrk";
        }
      else
        fetchurl {
          url = http://eclipse.ialto.com/eclipse/downloads/drops4/R-4.2.1-201209141800/eclipse-SDK-4.2.1-linux-gtk.tar.gz;
          sha256 = "1av6qm9wkbyk123qqf38f0jq4jv2bj9wp6fmpnl55zg6qr463c1w";
        };
    };
}
