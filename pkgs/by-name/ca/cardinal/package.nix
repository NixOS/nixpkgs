{
  stdenv,
  apple-sdk_15,
  fetchurl,
  cmake,
  dbus,
  fftwFloat,
  file,
  freetype,
  jansson,
  lib,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libarchive,
  libjack2,
  liblo,
  libsamplerate,
  libsndfile,
  makeWrapper,
  pkg-config,
  python3,
  speexdsp,
  libglvnd,
  headless ? false,
}:

stdenv.mkDerivation rec {
  pname = "cardinal";
  version = "25.06";

  src = fetchurl {
    url = "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal+deps-${version}.tar.xz";
    hash = "sha256-siZbbYrMGjhiof2M2ZBl2gekePuwsKvR8uZCdjyywiE=";
  };

  prePatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    file
    pkg-config
    makeWrapper
    python3
  ];

  buildInputs =
    [
      dbus
      fftwFloat
      freetype
      jansson
      libarchive
      liblo
      libsamplerate
      libsndfile
      speexdsp
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libX11
      libXcursor
      libXext
      libXrandr
      libglvnd # libGL.so
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin ([
      apple-sdk_15
    ]);

  hardeningDisable = [ "format" ];

  makeFlags =
    [
      "SYSDEPS=true"
      "PREFIX=$(out)"
    ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "CROSS_COMPILING=true"
    ++ lib.optional headless "HEADLESS=true";

  postPatch = lib.optionals stdenv.hostPlatform.isDarwin ''
    substituteInPlace ./src/CardinalRemote/main.cpp \
      --replace "/Library/Application Support/Cardinal" $out/share/Cardinal

    substituteInPlace ./src/CardinalCommon.cpp \
      --replace "/Library/Application Support/Cardinal" $out/share/Cardinal
  '';

  postInstall = lib.optionals stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/Cardinal \
    --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    wrapProgram $out/bin/CardinalMini \
    --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    # this doesn't work and is mainly just a test tool for the developers anyway.
    rm -f $out/bin/CardinalNative
  '';

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/bin $out/lib/{lv2,clap,vst,vst3} $out/share/{cardinal,doc/cardinal/docs}

        cp -rf bin/*.lv2      $out/lib/lv2/
        cp -rf bin/*.clap     $out/lib/clap/
        cp -rf bin/*.vst      $out/lib/vst/
        cp -rf bin/*.vst3      $out/lib/vst3/
        rm -rf $out/lib/lv2/*.lv2/resources
        rm -rf $out/lib/vst/*.vst/Contents/Resources
        rm -rf $out/lib/vst3/*.vst3/Contents/Resources
        rm -rf $out/lib/clap/*.clap/Contents/Resources

        cp -rf bin/CardinalNative.app       $out/bin/
        cp -rf bin/Cardinal.lv2/resources/* $out/share/cardinal/
        cp -rf README.md            $out/share/doc/cardinal/
        cp -rf docs/*.md docs/*.png $out/share/doc/cardinal/docs/
      ''
    else
      null;

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      magnetophon
      PowerUser64
      multivac61
    ];
    mainProgram = "Cardinal";
    platforms = lib.platforms.all;
  };
}
