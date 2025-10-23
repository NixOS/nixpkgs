{
  lib,
  stdenv,
  fetchsvn,
  cctools,
  libtiff,
  libpng,
  zlib,
  libwebp,
  libraw,
  openexr,
  openjpeg,
  libjpeg,
  jxrlib,
  pkg-config,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeimage";
  version = "3.18.0-unstable-2024-04-18";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/freeimage/svn/";
    rev = "1911";
    hash = "sha256-JznVZUYAbsN4FplnuXxCd/ITBhH7bfGKWXep2A6mius=";
  };

  sourceRoot = "${finalAttrs.src.name}/FreeImage/trunk";

  # Ensure that the bundled libraries are not used at all
  prePatch = ''
    rm -rf Source/Lib* Source/OpenEXR Source/ZLib
  '';

  # Tell patch to work with trailing carriage returns
  patchFlags = [
    "-p1"
    "--binary"
  ];

  patches = [
    ./unbundle.diff
    ./CVE-2020-24292.patch
    ./CVE-2020-24293.patch
    ./CVE-2020-24295.patch
    ./CVE-2021-33367.patch
    ./CVE-2021-40263.patch
    ./CVE-2021-40266.patch
    ./CVE-2023-47995.patch
    ./CVE-2023-47997.patch
  ];

  postPatch = ''
    # To support cross compilation, use the correct `pkg-config`.
    substituteInPlace Makefile.fip \
      --replace "pkg-config" "$PKG_CONFIG"
    substituteInPlace Makefile.gnu \
      --replace "pkg-config" "$PKG_CONFIG"
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    # Upstream Makefile hardcodes i386 and x86_64 architectures only
    substituteInPlace Makefile.osx --replace "x86_64" "arm64"
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    fixDarwinDylibNames
  ];

  buildInputs = [
    libtiff
    libtiff.dev_private
    libpng
    zlib
    libwebp
    libraw
    openexr
    openjpeg
    libjpeg
    libjpeg.dev_private
    jxrlib
  ];

  postBuild = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    make -f Makefile.fip
  '';

  INCDIR = "${placeholder "out"}/include";
  INSTALLDIR = "${placeholder "out"}/lib";

  preInstall = ''
    mkdir -p $INCDIR $INSTALLDIR
  ''
  # Workaround for Makefiles.osx not using ?=
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeFlagsArray+=( "INCDIR=$INCDIR" "INSTALLDIR=$INSTALLDIR" )
  '';

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      make -f Makefile.fip install
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s $out/lib/libfreeimage.3.dylib $out/lib/libfreeimage.dylib
    '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = with lib.licenses; [
      freeimage
      gpl2Only
      gpl3Only
    ];
    knownVulnerabilities = [
      "CVE-2024-31570"
      "CVE-2024-28584"
      "CVE-2024-28583"
      "CVE-2024-28582"
      "CVE-2024-28581"
      "CVE-2024-28580"
      "CVE-2024-28579"
      "CVE-2024-28578"
      "CVE-2024-28577"
      "CVE-2024-28576"
      "CVE-2024-28575"
      "CVE-2024-28574"
      "CVE-2024-28573"
      "CVE-2024-28572"
      "CVE-2024-28571"
      "CVE-2024-28570"
      "CVE-2024-28569"
      "CVE-2024-28568"
      "CVE-2024-28567"
      "CVE-2024-28566"
      "CVE-2024-28565"
      "CVE-2024-28564"
      "CVE-2024-28563"
      "CVE-2024-28562"
      "CVE-2024-9029"
      # "CVE-2023-47997"
      "CVE-2023-47996"
      # "CVE-2023-47995"
      "CVE-2023-47994"
      "CVE-2023-47993"
      "CVE-2023-47992"
      # "CVE-2021-40266"
      "CVE-2021-40265"
      "CVE-2021-40264"
      # "CVE-2021-40263"
      "CVE-2021-40262"
      # "CVE-2021-33367"
      # "CVE-2020-24295"
      "CVE-2020-24294"
      # "CVE-2020-24293"
      # "CVE-2020-24292"
      "CVE-2020-21426"
      "CVE-2019-12214"
      "CVE-2019-12212"
    ];
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
