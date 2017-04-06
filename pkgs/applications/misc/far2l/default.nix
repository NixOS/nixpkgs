{ stdenv, fetchFromGitHub, makeWrapper, cmake, pkgconfig, wxGTK30, glib, pcre, m4, bash,
  xdg_utils, xterm, gvfs, zip, unzip, gzip, bzip2, gnutar, p7zip, xz }:

stdenv.mkDerivation rec {
  rev = "c2f2b89db31b1c3cb9bed53267873f4cd7bc996d";
  build = "2017-03-18-${builtins.substring 0 10 rev}";
  name = "far2l-2.1.${build}";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = rev;
    sha256 = "1172ajg4n8g4ag14b6nb9lclwh2r6v7ccndmvhnj066w35ixnqgb";
  };

  nativeBuildInputs = [ cmake pkgconfig m4 makeWrapper ];

  buildInputs = [ wxGTK30 glib pcre ];

  postPatch = ''
    echo 'echo ${build}' > far2l/bootstrap/scripts/vbuild.sh

    substituteInPlace far2l/bootstrap/open.sh              \
      --replace 'gvfs-trash'  '${gvfs}/bin/gvfs-trash'
    substituteInPlace far2l/bootstrap/open.sh              \
      --replace 'xdg-open'    '${xdg_utils}/bin/xdg-open'  \
      --replace 'xterm'       '${xterm}/bin/xterm'
    substituteInPlace far2l/vtcompletor.cpp                \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'
    substituteInPlace multiarc/src/formats/zip/zip.cpp     \
      --replace '"unzip '     '"${unzip}/bin/unzip '       \
      --replace '"zip '       '"${zip}/bin/zip '
    substituteInPlace multiarc/src/formats/7z/7z.cpp       \
      --replace '"^7z '       '"^${p7zip}/lib/p7zip/7z '   \
      --replace '"7z '        '"${p7zip}/lib/p7zip/7z '
    substituteInPlace multiarc/src/formats/targz/targz.cpp \
      --replace '"xz '        '"${xz}/bin/xz '             \
      --replace '"gzip '      '"${gzip}/bin/gzip '         \
      --replace '"bzip2 '     '"${bzip2}/bin/bzip2 '       \
      --replace '"tar '       '"${gnutar}/bin/tar '
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    rm install/{far2l_askpass,far2l_sudoapp}
    mv install/far2l $out/bin/far2l
    mv install $out/share/far2l
    ln -s -r $out/bin/far2l $out/share/far2l/far2l_askpass
    ln -s -r $out/bin/far2l $out/share/far2l/far2l_sudoapp
  '';

  stripDebugList = "bin share";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An orthodox file manager";
    homepage = http://github.com/elfmz/far2l;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.all;
  };
}
