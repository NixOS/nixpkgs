{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper, cmake, pkgconfig, wxGTK30, glib, pcre, m4, bash,
  xdg_utils, gvfs, zip, unzip, gzip, bzip2, gnutar, p7zip, xz, imagemagick, darwin }:

let
  newer-colorer-schemes = fetchFromGitHub {
    owner = "colorer";
    repo = "Colorer-schemes";
    rev = "7c831f5e94a90530ace8b2bb9916210e3a2fcda6"; # 2019-11-28 (far2l has older Colorer-schemes)
    sha256 = "18vaahdz5i7xdf00c9h9kjjswm4jszywm8zkhva4c4ivr4qqnv2c";
  };
in
stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2019-12-14.git${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "dceaa3918ea2c5e43600bad3fc63f861b8d26fc4";
    sha256 = "1ssd3hwz4b7vl4r858d9whl61cn23pgcamcjmvfa6ysf4x2b7sgi";
  };

  nativeBuildInputs = [ cmake pkgconfig m4 makeWrapper imagemagick ];

  buildInputs = [ wxGTK30 glib pcre ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace far2l/bootstrap/trash.sh \
      --replace 'gvfs-trash'  '${gvfs}/bin/gvfs-trash'
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace far2l/CMakeLists.txt \
      --replace "-framework System" -lSystem
  '' + ''
    echo 'echo ${version}' > far2l/bootstrap/scripts/vbuild.sh
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

    cp ${newer-colorer-schemes}/hrc/hrc/base/nix.hrc     colorer/configs/base/hrc/base/
    cp ${newer-colorer-schemes}/hrc/hrc/base/cpp.hrc     colorer/configs/base/hrc/base/
    cp ${newer-colorer-schemes}/hrc/hrc/inet/jscript.hrc colorer/configs/base/hrc/base/
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps
    cp -dpR install $out/share/far2l
    mv $out/share/far2l/far2l $out/bin/
    ln -s -r --force $out/bin/far2l $out/share/far2l/far2l_askpass
    ln -s -r --force $out/bin/far2l $out/share/far2l/far2l_sudoapp

    cp ../far2l/DE/far2l.desktop $out/share/applications/far2l.desktop
    substituteInPlace $out/share/applications/far2l.desktop --replace \''${CMAKE_INSTALL_PREFIX} "$out"

    cp ../far2l/DE/icons/hicolor/1024x1024/apps/far2l.svg $out/share/icons/hicolor/scalable/apps/
    convert -size 128x128 ../far2l/DE/icons/far2l.svg $out/share/icons/far2l.png
    for size in 16x16 24x24 32x32 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512 1024x1024; do
      mkdir -p $out/share/icons/hicolor/$size/apps
      convert -size $size ../far2l/DE/icons/hicolor/$size/apps/far2l.svg $out/share/icons/hicolor/$size/apps/far2l.png
    done
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/far2l --argv0 $out/bin/far2l
  '';

  stripDebugList = "bin share";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An orthodox file manager";
    homepage = https://github.com/elfmz/far2l;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.all;
  };
}
