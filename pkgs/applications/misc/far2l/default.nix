{ stdenv, fetchFromGitHub, makeWrapper, cmake, pkgconfig, wxGTK30, glib, pcre, m4, bash,
  xdg_utils, gvfs, zip, unzip, gzip, bzip2, gnutar, p7zip, xz, imagemagick, darwin }:

with stdenv.lib;
stdenv.mkDerivation rec {
  rev = "73e52ccbc7626631b6898c7324413ee1fc09bc0e";
  build = "unstable-2017-09-25.git${builtins.substring 0 7 rev}";
  name = "far2l-2.1.${build}";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = rev;
    sha256 = "0pg1l2k5ycm6whr39gshpbgw62v51rfz3ddi6qhcx0nyzxcrczy5";
  };

  nativeBuildInputs = [ cmake pkgconfig m4 makeWrapper imagemagick ];

  buildInputs = [ wxGTK30 glib pcre ]
    ++ optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  patches = [ ./add-nix-syntax-highlighting.patch ];

  postPatch = optionalString stdenv.isLinux ''
    substituteInPlace far2l/bootstrap/open.sh \
      --replace 'gvfs-trash'  '${gvfs}/bin/gvfs-trash'
  '' + optionalString stdenv.isDarwin ''
    substituteInPlace far2l/CMakeLists.txt \
      --replace "-framework System" -lSystem
  '' + ''
    echo 'echo ${build}' > far2l/bootstrap/scripts/vbuild.sh
    substituteInPlace far2l/bootstrap/open.sh              \
      --replace 'xdg-open'    '${xdg_utils}/bin/xdg-open'
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
    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps
    cp -dpR install $out/share/far2l
    mv $out/share/far2l/far2l $out/bin/
    ln -s -r --force $out/bin/far2l $out/share/far2l/far2l_askpass
    ln -s -r --force $out/bin/far2l $out/share/far2l/far2l_sudoapp

    sed "s,/usr/bin/,$out/bin/," ../far2l/DE/far2l.desktop > $out/share/applications/far2l.desktop

    cp ../far2l/DE/icons/hicolor/1024x1024/apps/far2l.svg $out/share/icons/hicolor/scalable/apps/
    convert -size 128x128 ../far2l/DE/icons/far2l.svg $out/share/icons/far2l.png
    for size in 16x16 24x24 32x32 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512 1024x1024; do
      mkdir -p $out/share/icons/hicolor/$size/apps
      convert -size $size ../far2l/DE/icons/hicolor/$size/apps/far2l.svg $out/share/icons/hicolor/$size/apps/far2l.png
    done
  '';

  stripDebugList = "bin share";

  enableParallelBuilding = true;

  meta = {
    description = "An orthodox file manager";
    homepage = https://github.com/elfmz/far2l;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.all;
  };
}
