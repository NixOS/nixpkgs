{ stdenv, fetchurl, fetchpatch, pkgconfig
, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXcursor, libXrandr, libXinerama, libXext, harfbuzz, mesa }:

stdenv.mkDerivation rec {
  version = "1.9a";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "1k64pdapyj8a336jw3j61fhn0rp4q6az7d0dqp9r5n3d9rgwa5c0";
  };

  patches = [
    # http://www.openwall.com/lists/oss-security/2016/08/03/2
    (fetchpatch {
      name = "mupdf-fix-CVE-2016-6525.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=commitdiff_plain;h=39b0f07dd960f34e7e6bf230ffc3d87c41ef0f2e;hp=fa1936405b6a84e5c9bb440912c23d532772f958";
      sha256 = "1g9fkd1f5rx1z043vr9dj4934qf7i4nkvbwjc61my9azjrrc3jv7";
    })
    (fetchpatch {
      name = "mupdf-696941-fix-use-after-free.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=fa1936405b6a84e5c9bb440912c23d532772f958";
      sha256 = "02j9b6my1h3rb0sz9yp6gi7c4ldi3mz0z9s5i8g9cl0arxyzys5h";
    })
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.9a-openjpeg-2.1.1.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/mupdf/trunk/0001-mupdf-openjpeg.patch?id=9083dac2a398bfe694d31a0c6a0a839c5a756e53";
      sha256 = "14ndgy3w1sl25km9bcc2zfcxrcihqjw1sdzkpcw5g1mi7gcgxp3g";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib libX11 libXcursor libXext harfbuzz mesa libXrandr libXinerama freetype libjpeg jbig2dec openjpeg ];
  outputs = [ "bin" "dev" "out" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,jpeg,openjpeg,zlib}
  '';

  postInstall = ''
    for i in $out/lib/*.a; do
      so="''${i%.a}.so"
      gcc -shared -o $so.${version} -Wl,--whole-archive $i -Wl,--no-whole-archive
      ln -s $so.${version} $so
      rm $i
    done

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
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric vrthra fpletz ];
    platforms = platforms.linux;
  };
}
