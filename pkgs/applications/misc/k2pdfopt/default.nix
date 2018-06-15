{ stdenv, fetchzip, fetchurl, fetchpatch, cmake, pkgconfig
, zlib, libpng, openjpeg
, enableGSL ? true, gsl
, enableGhostScript ? true, ghostscript
, enableMuPDF ? true, mupdf
, enableJPEG2K ? true, jasper
, enableDJVU ? true, djvulibre
, enableGOCR ? false, gocr # Disabled by default due to crashes
, enableTesseract ? true, leptonica, tesseract
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "k2pdfopt-${version}";
  version = "2.42";

  src = fetchzip {
    url = "http://www.willus.com/k2pdfopt/src/k2pdfopt_v${version}_src.zip";
    sha256 = "1zag4jmkr0qrcpqqb5davmvdrabhdyz87q4zz0xpfkl6xw2dn9bk";
  };

  patches = [ ./k2pdfopt.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs =
  let
    mupdf_modded = mupdf.overrideAttrs (attrs: {
      name = "mupdf-1.10a";
      src = fetchurl {
        url = "https://mupdf.com/downloads/archive/mupdf-1.10a-source.tar.gz";
        sha256 = "0dm8wcs8i29aibzkqkrn8kcnk4q0kd1v66pg48h5c3qqp4v1zk5a";
      };
      # Excluded the pdf-*.c files, since they mostly just broke the #includes
      prePatch = ''
        cp ${src}/mupdf_mod/{font,stext-device,string}.c source/fitz/
        cp ${src}/mupdf_mod/font-win32.c source/pdf/
      '';
      # Patches from previous 1.10a version in nixpkgs
      patches = [
        # Compatibility with new openjpeg
        ./load-jpx.patch

        (fetchurl {
         name = "CVE-2017-5896.patch";
         url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=2c4e5867ee699b1081527bc6c6ea0e99a35a5c27";
         sha256 = "14k7x47ifx82sds1c06ibzbmcparfg80719jhgwjk6w1vkh4r693";
        })

        (fetchpatch {
          name = "mupdf-1.10a-shared_libs-1.patch";
          url = "https://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.10a-shared_libs-1.patch";
          sha256 = "0kg4vahp7hlyyj5hl18brk8s8xcbqrx19pqjzkfq6ha8mqa3k4ab";
        })
      ];

      # Override this since the jpeg directory was renamed libjpeg in mupdf 1.11
      preConfigure = ''
        # Don't remove mujs because upstream version is incompatible
        rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,jpeg,openjpeg,zlib}
      '';
      postPatch = let
        # OpenJPEG version is hardcoded in package source
        openJpegVersion = with stdenv;
          lib.concatStringsSep "." (lib.lists.take 2
          (lib.splitString "." (lib.getVersion openjpeg)));
        in ''
          sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
        '';
    });
    leptonica_modded = leptonica.overrideAttrs (attrs: {
      prePatch = ''
        cp ${src}/leptonica_mod/* src/
      '';
    });
    tesseract_modded = tesseract.overrideAttrs (attrs: {
      prePatch = ''
        cp ${src}/tesseract_mod/{ambigs.cpp,ccutil.h,ccutil.cpp} ccutil/
        cp ${src}/tesseract_mod/dawg.cpp api/
        cp ${src}/tesseract_mod/{imagedata.cpp,tessdatamanager.cpp} ccstruct/
        cp ${src}/tesseract_mod/openclwrapper.h opencl/
        cp ${src}/tesseract_mod/{tessedit.cpp,thresholder.cpp} ccmain/
        cp ${src}/tesseract_mod/tess_lang_mod_edge.h cube/
        cp ${src}/tesseract_mod/tesscapi.cpp api/
        cp ${src}/include_mod/{tesseract.h,leptonica.h} api/
      '';
      patches = [ ./tesseract.patch ];
    });
  in
    [ zlib libpng ] ++
    optional enableGSL gsl ++
    optional enableGhostScript ghostscript ++
    optional enableMuPDF mupdf_modded ++
    optional enableJPEG2K jasper ++
    optional enableDJVU djvulibre ++
    optional enableGOCR gocr ++
    optionals enableTesseract [ leptonica_modded tesseract_modded ];

  dontUseCmakeBuildDir = true;

  cmakeFlags = [ "-DCMAKE_C_FLAGS=-I${src}/include_mod" ];

  installPhase = ''
    install -D -m 755 k2pdfopt $out/bin/k2pdfopt
  '';

  meta = with stdenv.lib; {
    description = "Optimizes PDF/DJVU files for mobile e-readers (e.g. the Kindle) and smartphones";
    homepage = http://www.willus.com/k2pdfopt;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu danielfullmer ];
  };
}

