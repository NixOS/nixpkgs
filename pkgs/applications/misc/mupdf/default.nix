{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, freetype, harfbuzz, openjpeg
, jbig2dec, libjpeg , darwin
, enableX11 ? true, libX11, libXext, libXi, libXrandr
, enableCurl ? true, curl, openssl
, enableGL ? true, freeglut, libGLU
}:

let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.concatStringsSep "." (lib.lists.take 2
      (lib.splitString "." (lib.getVersion openjpeg)));


in stdenv.mkDerivation rec {
  version = "1.12.0";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "0mc7a92zri27lk17wdr2iffarbfi4lvrmxhc53sz84hm5yl56qsw";
  };

  patches = [
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.12-openjpeg-version.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/0001-mupdf-openjpeg.patch?h=packages/mupdf&id=a910cd33a2b311712f83710dc042fbe80c104306";
      sha256 = "05i9v2ia586jyjqdb7g68ss4vkfwgp6cwhagc8zzggsba83azyqk";
    })
    (fetchpatch {
      name = "CVE-2018-6544.1.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=commitdiff_plain;h=b03def134988da8c800adac1a38a41a1f09a1d89;hp=26527eef77b3e51c2258c8e40845bfbc015e405d";
      sha256 = "1rlmjibl73ls8xfpsz69axa3lw5l47vb0a1dsjqziszsld4lpj5i";
    })
    (fetchpatch {
      name = "CVE-2018-6544.2.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=26527eef77b3e51c2258c8e40845bfbc015e405d;hp=ab98356f959c7a6e94b1ec10f78dd2c33ed3f3e7";
      sha256 = "1brcc029s5zmd6ya0d9qk3mh9qwx5g6vhsf1j8h879092sya5627";
    })
    (fetchpatch {
      # Bugs 698804/698810/698811, 698819: Keep PDF object numbers below limit.
      name = "CVE-2017-17858.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=55c3f68d638ac1263a386e0aaa004bb6e8bde731";
      sha256 = "1bf683d59i5009cv1hhmwmrp2rsb75cbf98qd44dk39cpvq8ydwv";
    })
    (fetchpatch {
      # Bug 698825: Do not drop borrowed colorspaces.
      name = "CVE-2018-1000051.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=321ba1de287016b0036bf4a56ce774ad11763384";
      sha256 = "0jbcc9j565q5y305pi888qzlp83zww6nhkqbsmkk91gim958zikm";
    })
    (fetchpatch {
      # Bug 698908 preprecondition: Add portable pseudo-random number generator based on the lrand48 family.
      name = "CVE-2018-6187.0.1.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=2d5b4683e912d6e6e1f1e2ca5aa0297beb3e6807";
      sha256 = "028bxinbjs5gg9myjr3vs366qxg9l2iyba2j3pxkxsh1851hj728";
    })
    (fetchpatch {
      # Bug 698908 precondition: Fix "being able to search for redacted text" bug.
      name = "CVE-2018-6187.0.2.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=25593f4f9df0c4a9b9adaa84aaa33fe2a89087f6";
      sha256 = "195y69c3f8yqxcsa0bxrmxbdc3fx1dzvz8v66i56064mjj0mx04s";
    })
    (fetchpatch {
      # Bug 698908: Resize object use and renumbering lists after repair.
      name = "CVE-2018-6187.1.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=3e30fbb7bf5efd88df431e366492356e7eb969ec";
      sha256 = "0wzbqj750h06q1wa6vxbpv5a5q9pfg0cxjdv88yggkrjb3vrkd9j";
    })
    (fetchpatch {
      # Bug 698908: Plug PDF object leaks when decimating pages in pdfposter.
      name = "CVE-2018-6187.2.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=a71e7c85a9f2313cde20d4479cd727a5f5518ed2";
      sha256 = "1pcjkq8lg6l2m0186rl79lilg79crgdvz9hrmm3w60gy2gxkgksc";
    })
    (fetchpatch {
      # Bug 698916: Indirect object numbers must be in range.
      name = "CVE-2018-6192.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=5e411a99604ff6be5db9e273ee84737204113299";
      sha256 = "134zc07fp0p1mwqa8xrkq3drg4crajzf1hjf4mdwmcy1jfj2pfhj";
    })
  ]

  # Use shared libraries to decrease size
  ++ stdenv.lib.optional (!stdenv.isDarwin) ./mupdf-1.12-shared_libs-1.patch

  ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch
  ;

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ freetype harfbuzz openjpeg jbig2dec libjpeg freeglut libGLU ]
                ++ lib.optionals enableX11 [ libX11 libXext libXi libXrandr ]
                ++ lib.optionals enableCurl [ curl openssl ]
                ++ lib.optionals enableGL (
                  if stdenv.isDarwin then
                    with darwin.apple_sdk.frameworks; [ GLUT OpenGL ]
                  else
                    [ freeglut libGLU ])
                ;
  outputs = [ "bin" "dev" "out" "man" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Version: ${version}
    Libs: -L$out/lib -lmupdf -lmupdfthird
    Cflags: -I$dev/include
    EOF

    moveToOutput "bin" "$bin"
    mkdir -p $bin/share/applications
    cat > $bin/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$bin/bin/mupdf-x11 %f
    Terminal=false
    EOF
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://mupdf.com;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ viric vrthra fpletz ];
    platforms = platforms.unix;
  };
}
