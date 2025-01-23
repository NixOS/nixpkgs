{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  autoconf,
  automake,
  libtool,
  makeWrapper,
  wget,
  xxd,
  desktop-file-utils,
  file,
  gnupg,
  glib,
  zlib,
  cairo,
  openssl,
  fuse,
  xz,
  squashfuse,
  inotify-tools,
  libarchive,
  squashfsTools,
  gtest,
}:

let

  appimagekit_src = fetchFromGitHub {
    owner = "AppImage";
    repo = "AppImageKit";
    rev = "8bbf694455d00f48d835f56afaa1dabcd9178ba6";
    hash = "sha256-pqg+joomC5CI9WdKP/h/XKPsruMgZEaIOjPLOqnNPZw=";
    fetchSubmodules = true;
  };

  # squashfuse adapted to nix from cmake experession in "${appimagekit_src}/lib/libappimage/cmake/dependencies.cmake"
  appimagekit_squashfuse = squashfuse.overrideAttrs rec {
    pname = "squashfuse";
    version = "unstable-2016-10-09";

    src = fetchFromGitHub {
      owner = "vasi";
      repo = pname;
      rev = "1f980303b89c779eabfd0a0fdd36d6a7a311bf92";
      sha256 = "sha256-BZd1+7sRYZHthULKk3RlgMIy4uCUei45GbSEiZxLPFM=";
    };

    patches = [
      "${appimagekit_src}/lib/libappimage/src/patches/squashfuse.patch"
      "${appimagekit_src}/lib/libappimage/src/patches/squashfuse_dlopen.patch"
    ];

    postPatch = ''
      cp -v ${appimagekit_src}/lib/libappimage/src/patches/squashfuse_dlopen.[hc] .
    '';

    # Workaround build failure on -fno-common toolchains:
    #   ld: libsquashfuse_ll.a(libfuseprivate_la-fuseprivate.o):(.bss+0x8):
    #     multiple definition of `have_libloaded'; runtime.4.o:(.bss.have_libloaded+0x0): first defined here
    env.NIX_CFLAGS_COMPILE = "-fcommon";

    preConfigure = ''
      sed -i "/PKG_CHECK_MODULES.*/,/,:./d" configure
      sed -i "s/typedef off_t sqfs_off_t/typedef int64_t sqfs_off_t/g" common.h
    '';

    configureFlags = [
      "--disable-demo"
      "--disable-high-level"
      "--without-lzo"
      "--without-lz4"
    ];

    postConfigure = ''
      sed -i "s|XZ_LIBS = -llzma |XZ_LIBS = -Bstatic -llzma/|g" Makefile
    '';

    # only static libs and header files
    installPhase = ''
      mkdir -p $out/lib $out/include
      cp -v ./.libs/*.a $out/lib
      cp -v ./*.h $out/include
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "appimagekit";
  version = "unstable-2020-12-31";

  src = appimagekit_src;

  patches = [ ./nix.patch ];

  postPatch = ''
    patchShebangs src/embed-magic-bytes-in-file.sh
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    autoconf
    automake
    libtool
    wget
    xxd
    desktop-file-utils
    makeWrapper
  ];

  buildInputs = [
    glib
    zlib
    cairo
    openssl
    fuse
    xz
    inotify-tools
    libarchive
    squashfsTools
    appimagekit_squashfuse
  ];

  preConfigure = ''
    export HOME=$(pwd)
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_XZ=ON"
    "-DUSE_SYSTEM_SQUASHFUSE=ON"
    "-DSQUASHFUSE=${appimagekit_squashfuse}"
    "-DUSE_SYSTEM_LIBARCHIVE=ON"
    "-DUSE_SYSTEM_GTEST=ON"
    "-DUSE_SYSTEM_MKSQUASHFS=ON"
    "-DTOOLS_PREFIX=${stdenv.cc.targetPrefix}"
  ];

  postInstall = ''
    mkdir -p $out/lib/appimagekit
    cp "${squashfsTools}/bin/mksquashfs" "$out/lib/appimagekit/"
    cp "${desktop-file-utils}/bin/desktop-file-validate" "$out/bin"

    wrapProgram "$out/bin/appimagetool" \
      --prefix PATH : "${
        lib.makeBinPath [
          file
          gnupg
        ]
      }" \
      --unset SOURCE_DATE_EPOCH
  '';

  nativeCheckInputs = [ gtest ];

  # for debugging
  passthru = {
    squashfuse = appimagekit_squashfuse;
  };

  meta = with lib; {
    description = "Tool to package desktop applications as AppImages";
    longDescription = ''
      AppImageKit is an implementation of the AppImage format that
      provides tools such as appimagetool and appimaged for handling
      AppImages.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ taeer ];
    homepage = src.meta.homepage;
    platforms = platforms.linux;
  };
}
