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
        ensureDir $out
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
        ensureDir $out/share/applications
        cp ${desktopItem}/share/applications/* $out/share/applications
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

}

