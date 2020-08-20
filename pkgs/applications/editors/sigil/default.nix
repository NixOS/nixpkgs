{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, xercesc, fetchpatch
, qtbase, qttools, qtwebkit, qtxmlpatterns
, python3, python3Packages
}:

mkDerivation rec {
  pname = "sigil";
  version = "0.9.14";

  src = fetchFromGitHub {
    sha256 = "0fmfbfpnmhclbbv9cbr1xnv97si6ls7331kk3ix114iqkngqwgl1";
    rev = version;
    repo = "Sigil";
    owner = "Sigil-Ebook";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-14452.part-1.patch";
      url = "https://github.com/Sigil-Ebook/Sigil/commit/369eebe936e4a8c83cc54662a3412ce8bef189e4.patch";
      sha256 = "07pgy89lsp7332zgdraji4xbiy0yri00nfdd311nxi2scmf55izv";
    })
    (fetchpatch {
      name = "CVE-2019-14452.part-2.patch";
      url = "https://github.com/Sigil-Ebook/Sigil/commit/0979ba8d10c96ebca330715bfd4494ea0e019a8f.patch";
      sha256 = "1fsqcgh6y3137fw5989gxv5wryvklcfdcqyk4pgi0nq7m6ydbj30";
    })
    (fetchpatch {
      name = "CVE-2019-14452.part-3.patch";
      url = "https://github.com/Sigil-Ebook/Sigil/commit/04e2f280cc4a0766bedcc7b9eb56449ceecc2ad4.patch";
      sha256 = "1mza8kj9gyp25m0in4fdzad2w5cm2wy18ds0308qdx24bdlmr4j5";
    })
  ];

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [
    boost xercesc qtbase qttools qtwebkit qtxmlpatterns
    python3Packages.lxml ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = https://github.com/Sigil-Ebook/Sigil/;
    license = licenses.gpl3;
    # currently unmaintained
    platforms = platforms.linux;
  };
}
