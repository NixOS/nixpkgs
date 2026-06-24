{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPackages,
  pkgsHostHost,
  pkg-config,
  which,
  makeWrapper,
  zlib,
  bzip2,
  brotli,
  libpng,
  gnumake,
  glib,

  # FreeType supports LCD filtering (colloquially referred to as sub-pixel rendering).
  # LCD filtering is also known as ClearType and covered by several Microsoft patents.
  # This option allows it to be disabled. See http://www.freetype.org/patents.html.
  useEncumberedCode ? true,

  # for passthru.tests
  cairo,
  fontforge,
  ghostscript,
  graphicsmagick,
  gtk3,
  harfbuzz,
  imagemagick,
  pango,
  poppler,
  python3,
  qt5,
  texmacs,
  ttfautohint,
  testers,
  __flattenIncludeHackHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freetype";
  version = "2.14.3";

  src =
    let
      inherit (finalAttrs) pname version;
    in
    fetchurl {
      url = "mirror://savannah/freetype/freetype-${version}.tar.xz";
      sha256 = "sha256-NrxPHMQTM1No7mVsQq/KZcWjmH6HaMwozxG6d154Wl8=";
    };

  propagatedBuildInputs = [
    zlib
    bzip2
    brotli
    libpng
  ]; # needed when linking against freetype

  # dependence on harfbuzz is looser than the reverse dependence
  nativeBuildInputs = [
    pkg-config
    which
    __flattenIncludeHackHook
  ]
  ++ lib.optional (!stdenv.hostPlatform.isWindows) makeWrapper
  # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
  ++ lib.optional (!stdenv.hostPlatform.isLinux) gnumake;

  patches = [
    ./enable-table-validation.patch

    # https://project-zero.issues.chromium.org/issues/505355061
    # https://gitlab.freedesktop.org/freetype/freetype/-/work_items/1419
    # https://gitlab.freedesktop.org/freetype/freetype/-/work_items/1420
    (fetchpatch {
      name = "truetype-shz-limit-heap-buffer-overflow-part1.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/1803559c4ee407d0bcbf2a67dbe96690cee869d2.patch";
      hash = "sha256-zxtJ2pJz8pNofgYrJ6c8/eZqRvxTotanF2IdU9ckpM4=";
    })
    (fetchpatch {
      name = "truetype-shz-limit-heap-buffer-overflow-part2.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/7d600a022e1d813e85a8c94ffd395f6135872267.patch";
      hash = "sha256-aHE11C9Cr23D2lqNmTVUDA5E07xxUm+AcYdWJG9zLFs=";
    })

    # https://project-zero.issues.chromium.org/issues/505357209
    # https://gitlab.freedesktop.org/freetype/freetype/-/work_items/1421
    (fetchpatch {
      name = "truetype-iup-integer-overflow.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/7974be74d8b5a2fbf99aa88f0461d1f80af51cee.patch";
      hash = "sha256-b5Px0ALsnC5K1+601YioAjCLkLVXNnvTIZ1aQtCeNoQ=";
    })

    # https://project-zero.issues.chromium.org/issues/506902245
    # https://gitlab.freedesktop.org/freetype/freetype/-/work_items/1423
    # https://gitlab.freedesktop.org/freetype/freetype/-/merge_requests/428
    (fetchpatch {
      name = "truetype-variation-handling-signednes-mismatch.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/0d45c7f1911bc6db0bf072eea0c8cdccd77bc6b3.patch";
      hash = "sha256-bw/9O86sZQa+vwdgx2MTqxWi6vjMcRTyC42ba9CaZ3I=";
    })

    # prerequisite for the below to apply, since this changes formatting of
    # affected code.
    (fetchpatch {
      name = "ftobjs-formatting.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/590b77014bd920d0bdf64c039fddbce89a288b83.patch";
      hash = "sha256-govOzLBzQMAjSKABVFryDnSn2by2f/W9BgGG3o+qSuE=";
    })

    # https://project-zero.issues.chromium.org/issues/507321912
    # https://gitlab.freedesktop.org/freetype/freetype/-/work_items/1425
    (fetchpatch {
      name = "sub-byte-bitmaps-heap-buffer-over-read.patch";
      url = "https://gitlab.freedesktop.org/freetype/freetype/-/commit/cbe12767ea73d1006edc75fcd61c0b0d2a88f34e.patch";
      hash = "sha256-jMeqY9uX7Ryfdd8icGDT4kEKl6aGRWafSN8GzOhGW7g=";
    })
  ]
  ++ lib.optional useEncumberedCode ./enable-subpixel-rendering.patch;

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--bindir=$(dev)/bin"
    "--enable-freetype-config"
  ];

  env = {
    # native compiler to generate building tool
    CC_BUILD = "${buildPackages.stdenv.cc}/bin/cc";

    # The asm for armel is written with the 'asm' keyword.
    CFLAGS =
      lib.optionalString stdenv.hostPlatform.isAarch32 "-std=gnu99"
      + lib.optionalString stdenv.hostPlatform.is32bit " -D_FILE_OFFSET_BITS=64";
  }
  // lib.optionalAttrs (!stdenv.hostPlatform.isWindows && stdenv.cc.bintools.isLLVM) {
    # Needs to be unset when using LLVM or else it tries to include Windows headers on Linux
    RC = "";
  };

  enableParallelBuilding = true;

  doCheck = true;

  # pkgsCross.mingwW64.pkg-config doesn't build
  # makeWrapper doesn't cross-compile to windows #120726
  postInstall = ''
    substituteInPlace $dev/bin/freetype-config \
      --replace ${buildPackages.pkg-config} ${pkgsHostHost.pkg-config}
  ''
  + lib.optionalString (!stdenv.hostPlatform.isMinGW) ''

    wrapProgram "$dev/bin/freetype-config" \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH:$dev/lib/pkgconfig"
  '';

  passthru.tests = {
    inherit
      cairo
      fontforge
      ghostscript
      graphicsmagick
      gtk3
      harfbuzz
      imagemagick
      pango
      poppler
      texmacs
      ttfautohint
      ;
    inherit (python3.pkgs) freetype-py;
    inherit (qt5) qtbase;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Font rendering engine";
    mainProgram = "freetype-config";
    longDescription = ''
      FreeType is a portable and efficient library for rendering fonts. It
      supports TrueType, Type 1, CFF fonts, and WOFF, PCF, FNT, BDF and PFR
      fonts. It has a bytecode interpreter and has an automatic hinter called
      autofit which can be used instead of hinting instructions included in
      fonts.
    '';
    homepage = "https://www.freetype.org/";
    changelog = "https://gitlab.freedesktop.org/freetype/freetype/-/raw/VER-${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }/docs/CHANGES";
    license = lib.licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    platforms = lib.platforms.all;
    pkgConfigModules = [ "freetype2" ];
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
