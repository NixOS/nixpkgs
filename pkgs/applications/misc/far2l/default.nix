{ lib, stdenv, fetchFromGitHub, makeWrapper, cmake, pkg-config, wxGTK30, glib, pcre, m4, bash
, xdg-utils, gvfs, zip, unzip, gzip, bzip2, gnutar, p7zip, xz, imagemagick
, libuchardet, spdlog, xercesc, openssl, libssh, samba, neon, libnfs, libarchive }:

stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2020-12-30.git${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "52c1372441443aafd1a7dff6f17969a6ec19885d";
    sha256 = "0s7427fgxzj5zkyy6mhb4y5hqa6adsr30m0bigycp12b0495ryx0";
  };

  nativeBuildInputs = [ cmake pkg-config m4 makeWrapper imagemagick ];

  buildInputs = [ wxGTK30 glib pcre libuchardet spdlog xercesc ] # base requirements of the build
    ++ [ openssl libssh samba neon libnfs libarchive ]; # optional feature packages, like protocol support for Network panel, or archive formats
    #++ lib.optional stdenv.isDarwin Cocoa # Mac support -- disabled, see "meta.broken" below

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace far2l/bootstrap/trash.sh \
      --replace 'gvfs-trash'  '${gvfs}/bin/gvfs-trash'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace far2l/CMakeLists.txt \
      --replace "-framework System" -lSystem
  '' + ''
    echo 'echo ${version}' > far2l/bootstrap/scripts/vbuild.sh
    substituteInPlace far2l/bootstrap/open.sh              \
      --replace 'xdg-open'    '${xdg-utils}/bin/xdg-open'
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

    cp ../far2l/DE/far2l.desktop $out/share/applications/far2l.desktop
    substituteInPlace $out/share/applications/far2l.desktop --replace \''${CMAKE_INSTALL_PREFIX} "$out"

    cp ../far2l/DE/icons/hicolor/1024x1024/apps/far2l.svg $out/share/icons/hicolor/scalable/apps/
    convert -size 128x128 ../far2l/DE/icons/far2l.svg $out/share/icons/far2l.png
    for size in 16x16 24x24 32x32 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512 1024x1024; do
      mkdir -p $out/share/icons/hicolor/$size/apps
      convert -size $size ../far2l/DE/icons/hicolor/$size/apps/far2l.svg $out/share/icons/hicolor/$size/apps/far2l.png
    done
  '' + lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/far2l --argv0 $out/bin/far2l
  '';

  stripDebugList = [ "bin" "share" ];

  meta = with lib; {
    description = "Linux port of FAR Manager v2, a program for managing files and archives in Windows operating systems";
    homepage = "https://github.com/elfmz/far2l";
    license = licenses.gpl2Plus; # NOTE: might change in far2l repo soon, check next time
    maintainers = with maintainers; [ volth hypersw ];
    platforms = platforms.all;
    # fails to compile with:
    # error: no member named 'st_ctim' in 'stat'
    broken = stdenv.isDarwin;
  };
}
