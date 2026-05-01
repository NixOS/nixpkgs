{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  biber,

  # nativeBuildInputs
  bison,
  cmake,
  curl,
  flex,
  fop,
  libxslt,
  pkg-config,
  writableTmpDirAsHomeHook,

  # buildInputs
  apr,
  aprutil,
  boost,
  bzip2,
  cairo,
  expat,
  fontconfig,
  freetype,
  fribidi,
  gd,
  gmp,
  graphite2,
  harfbuzzFull,
  hunspell,
  libjpeg,
  log4cxx,
  xz,
  mpfr,
  mpfi,
  libmspack,
  libressl,
  pixman,
  libpng,
  popt,
  uriparser,
  zziplib,
  qt6Packages,
}:
let
  # This is needed for some bootstrap packages.
  webArchivePrefix = "https://web.archive.org/web/20250323131915if_";
  miktexRemoteRepository = "https://ctan.org/tex-archive/systems/win32/miktex/tm/packages";
  miktexLocalRepository =
    runCommand "miktex-local-repository"
      {
        src1 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-zzdb1-2.9.tar.lzma";
          hash = "sha256-XYhbKlxhVSOlCcm0IOs2ddFgAt/CWXJoY6IuLSw74y4=";
        };
        src2 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-zzdb3-2.9.tar.lzma";
          hash = "sha256-5vLuGwjddqtJ5F/DtVKuRVRqgGNbkGFxRF41cXwseIs=";
        };
        src3 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-config-2.9.tar.lzma";
          hash = "sha256-fkh5KL+BU+gl8Sih8xBLi1DOx2vMuSflXlSTchjlGWQ=";
        };
        src4 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-dvips.tar.lzma";
          hash = "sha256-eJQdLhYetNlXAyyiGD/JRDA3fv0BbALwXtNfRxkLM7o=";
        };
        src5 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-fontconfig.tar.lzma";
          hash = "sha256-dxH/0iIL3SnjCSXLGAcNTb5cGJb5AQmV/JbH5CcPHdk=";
        };
        src6 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/miktex-misc.tar.lzma";
          hash = "sha256-ysNREvnKWseqqN59cwNzlV21UmccbjSGFyno8lv2H+M=";
        };
        src7 = fetchurl {
          url = "${webArchivePrefix}/${miktexRemoteRepository}/tetex.tar.lzma";
          hash = "sha256-DE1o66r2SFxxxuYeCRuFn6L1uBn26IFnje9b/qeVl6Q=";
        };
      }
      ''
        mkdir $out
        cp $src1 $out/miktex-zzdb1-2.9.tar.lzma
        cp $src2 $out/miktex-zzdb3-2.9.tar.lzma
        cp $src3 $out/miktex-config-2.9.tar.lzma
        cp $src4 $out/miktex-dvips.tar.lzma
        cp $src5 $out/miktex-fontconfig.tar.lzma
        cp $src6 $out/miktex-misc.tar.lzma
        cp $src7 $out/tetex.tar.lzma
      '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "miktex";
  version = "25.4";

  src = fetchFromGitHub {
    owner = "miktex";
    repo = "miktex";
    tag = finalAttrs.version;
    hash = "sha256-3QGW8rsettA+Jtrsi9C5ONIG4vP+iuUEUi9dGHfWMSY=";
  };

  patches = [
    ./startup-config-support-nix-store.patch
    # Miktex will search exectables in "GetMyPrefix(true)/bin".
    # The path evaluate to "/usr/bin" in FHS style linux distribution,
    # compared to "/nix/store/.../bin" in NixOS.
    # As a result, miktex will fail to find e.g. 'pkexec','ksudo','gksu'
    # under /run/wrappers/bin in NixOS.
    # We fix this by adding the PATH environment variable to exectables' search path.
    ./find-exectables-in-path.patch
  ];

  postPatch = ''
    # dont symlink fontconfig to /etc/fonts/conf.d
    substituteInPlace Programs/MiKTeX/miktex/topics/fontmaps/commands/FontMapManager.cpp \
      --replace-fail 'this->ctx->session->IsAdminMode()' 'false'

    substituteInPlace \
      Libraries/MiKTeX/App/app.cpp \
      Programs/Editors/TeXworks/miktex/miktex-texworks.cpp \
      Programs/MiKTeX/Console/Qt/main.cpp \
      Programs/MiKTeX/PackageManager/mpm/mpm.cpp \
      Programs/MiKTeX/Yap/MFC/StdAfx.h \
      Programs/MiKTeX/initexmf/initexmf.cpp \
      Programs/MiKTeX/miktex/miktex.cpp \
      --replace-fail "log4cxx/rollingfileappender.h" "log4cxx/rolling/rollingfileappender.h"

    substitute cmake/modules/FindPOPPLER_QT5.cmake \
      cmake/modules/FindPOPPLER_QT6.cmake \
      --replace-fail "QT5" "QT6" \
      --replace-fail "qt5" "qt6"

    substituteInPlace Programs/TeXAndFriends/omega/otps/source/outocp.c \
      --replace-fail 'fprintf(stderr, s);' 'fprintf(stderr, "%s", s);'
  ''
  # This patch fixes mismatch char types (signed int and unsigned int) on aarch64-linux platform.
  # Should not be applied to other platforms otherwise the build will fail.
  + lib.optionalString (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) ''
    sed -i 's/--using-namespace=MiKTeX::TeXAndFriends/& --chars-are-unsigned/g' \
      Programs/TeXAndFriends/Knuth/web/CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    curl
    flex
    fop
    libxslt
    pkg-config
    writableTmpDirAsHomeHook
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
    qt6Packages.qt5compat
  ];

  buildInputs = [
    apr
    aprutil
    boost
    bzip2
    cairo
    expat
    fontconfig
    freetype
    fribidi
    gd
    gmp
    graphite2
    harfbuzzFull
    hunspell
    libjpeg
    log4cxx
    xz
    mpfr
    mpfi
    libmspack
    libressl
    pixman
    libpng
    popt
    uriparser
    zziplib
    qt6Packages.poppler
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_BOOTSTRAPPING" true)
    (lib.cmakeBool "USE_SYSTEM_POPPLER" true)
    (lib.cmakeBool "USE_SYSTEM_POPPLER_QT" true)
    (lib.cmakeBool "MIKTEX_SELF_CONTAINED" false)
    # Miktex infers install prefix by stripping CMAKE_INSTALL_BINDIR from the called program.
    # It should not be set to absolute path in default cmakeFlags, otherwise an infinite loop will happen.
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "libexec")
    (lib.cmakeFeature "MIKTEX_SYSTEM_LINK_TARGET_DIR" "${placeholder "out"}/bin")
    (lib.cmakeFeature "MIKTEX_USER_LINK_TARGET_DIR" "${placeholder "out"}/bin")
  ];

  env = {
    LANG = "C.UTF-8";
    MIKTEX_REPOSITORY = "file://${miktexLocalRepository}/";
  };

  enableParallelBuilding = false;

  enableParallelChecking = false;

  doCheck = true;

  # Todo: figure out the exact binary to be Qt wrapped.
  dontWrapQtApps = true;

  postFixup = ''
    wrapQtApp $out/bin/miktex-console
    wrapQtApp $out/bin/miktex-texworks
    $out/bin/miktexsetup finish --verbose
  ''
  # Biber binary is missing on ctan.org for aarch64-linux platform.
  + lib.optionalString (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) ''
    ln -sf ${biber}/bin/biber $out/bin/biber
  '';

  meta = {
    description = "Modern TeX distribution";
    homepage = "https://miktex.org";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      lppl13c
      gpl2Plus
      gpl3Plus
      publicDomain
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
