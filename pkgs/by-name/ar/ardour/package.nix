{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  fetchzip,
  alsa-lib,
  apple-sdk,
  aubio,
  boost,
  cairomm,
  cppunit,
  curl,
  darwin,
  dbus,
  doxygen,
  ffmpeg,
  fftw,
  fftwSinglePrec,
  fixDarwinDylibNames,
  flac,
  fluidsynth,
  glibc,
  glibmm,
  graphviz,
  harvid,
  hidapi,
  installShellFiles,
  itstool,
  kissfft,
  libarchive,
  libjack2,
  liblo,
  libltc,
  libogg,
  libpulseaudio,
  librdf_rasqal,
  libsamplerate,
  libsigcxx,
  libsndfile,
  libusb1,
  libuv,
  libwebsockets,
  libxi,
  libxml2,
  libxslt,
  lilv,
  lrdf,
  lv2,
  makeWrapper,
  pango,
  pangomm,
  perl,
  pkg-config,
  python3,
  qm-dsp,
  readline,
  rubberband,
  serd,
  sord,
  soundtouch,
  sratom,
  suil,
  taglib,
  vamp-plugin-sdk,
  wafHook,
  which,
  writableTmpDirAsHomeHook,
  xjadeo,
  libxrandr,
  libxinerama,
  libjpeg,
  optimize ? true, # disable to print Lua DSP script output to stdout
  videoSupport ? true,
}:
let
  videoInputs = [
    harvid
    xjadeo
  ];

  bundledContent = fetchzip {
    url = "https://web.archive.org/web/20221026200824/http://stuff.ardour.org/loops/ArdourBundledMedia.zip";
    hash = "sha256-IbPQWFeyMuvCoghFl1ZwZNNcSvLNsH84rGArXnw+t7A=";
    # archive does not contain a single folder at the root
    stripRoot = false;
  };

  generic = stdenv.mkDerivation (finalAttrs: {
    pname = "ardour";
    version = "9.7";

    # We can't use `fetchFromGitea` here, as attempting to fetch release archives from git.ardour.org
    # result in an empty archive. See https://tracker.ardour.org/view.php?id=7328 for more info.
    src = fetchgit {
      url = "git://git.ardour.org/ardour/ardour.git";
      tag = finalAttrs.version;
      hash = "sha256-6gtlnk/oPXWJcN5tcb1r7dXyLpHPTSJwd8VfOjjFnWQ=";
    };

    patches = [
      # AS=as in the environment causes build failure https://tracker.ardour.org/view.php?id=8096
      ./as-flags.patch
      ./default-plugin-search-paths.patch
    ];

    # Ardour's wscript requires git revision and date to be available.
    # Since they are not, let's generate the file manually.
    postPatch = ''
      printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "${finalAttrs.version}"; const char* date = ""; }\n' > libs/ardour/revision.cc
      patchShebangs ./tools/
      substituteInPlace libs/ardour/video_tools_paths.cc \
        --replace-fail 'ffmpeg_exe = X_("");' 'ffmpeg_exe = X_("${lib.getExe ffmpeg}");' \
        --replace-fail 'ffprobe_exe = X_("");' 'ffprobe_exe = X_("${lib.getExe' ffmpeg "ffprobe"}");'
    ''
    + lib.optionalString videoSupport ''
      substituteInPlace libs/ardour/video_tools_paths.cc \
        --replace-fail 'harvid_exe = "";' 'harvid_exe ="${lib.getExe harvid}";' \
        --replace-fail 'xjadeo_exe = X_("");' 'xjadeo_exe = X_("${lib.getExe' xjadeo "xjremote"}");'
    '';

    nativeBuildInputs = [
      doxygen
      graphviz # for dot
      installShellFiles
      itstool
      makeWrapper
      perl
      pkg-config
      python3
      wafHook
    ];

    buildInputs = [
      aubio
      boost
      cairomm
      cppunit
      curl
      ffmpeg
      fftw
      fftwSinglePrec
      flac
      fluidsynth
      glibmm
      hidapi
      itstool
      kissfft
      libarchive
      libjack2
      libjpeg
      liblo
      libltc
      libogg
      librdf_rasqal
      libsamplerate
      libsigcxx
      libsndfile
      libusb1
      libuv
      libwebsockets
      libxml2
      libxslt
      lilv
      lrdf
      lv2
      pango
      pangomm
      perl
      python3
      qm-dsp
      readline
      rubberband
      serd
      sord
      soundtouch
      sratom
      suil
      taglib
      vamp-plugin-sdk
    ]
    ++ lib.optionals videoSupport videoInputs;

    wafConfigureFlags = [
      "--cxx17"
      "--docs"
      "--no-phone-home"
      "--ptformat"
      # since we don't have https://github.com/agfline/LibAAF yet,
      # we need to use some of ardours internal libs, see:
      # https://discourse.ardour.org/t/ardour-8-2-released/109615/6
      # and
      # https://discourse.ardour.org/t/ardour-8-2-released/109615/8
      # "--use-external-libs"
    ]
    ++ lib.optional finalAttrs.doCheck "--test"
    ++ lib.optional optimize "--optimize";

    env = {
      NIX_CFLAGS_COMPILE = toString [
        # 'ioprio_set' syscall support:
        # compiler doesn't find headers without these:
        "-I${lib.getInclude serd}/include/serd-0"
        "-I${lib.getInclude sratom}/include/sratom-0"
        "-I${lib.getInclude sord}/include/sord-0"
      ];
      LINKFLAGS = "-lpthread";
    };

    postInstall = ''
      installManPage ardour.1
    '';

    doCheck = true;

    checkPhase = ''
      runHook preHook
      ./waf test
      runHook postHook
    '';

    meta = {
      description = "Multi-track hard disk recording software";
      longDescription = ''
        Ardour is a digital audio workstation (DAW), you can use it to
        record, edit and mix multi-track audio and midi. Produce your
        own CDs. Mix video soundtracks. Experiment with new ideas about
        music and sound.

        Please consider supporting the ardour project financially:
        https://community.ardour.org/donate
      '';
      homepage = "https://ardour.org/";
      license = lib.licenses.gpl2Plus;
      mainProgram = "ardour9";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      maintainers = with lib.maintainers; [
        magnetophon
        mitchmindtree
        ryand56
      ];
    };
  });

  linux = generic.overrideAttrs (
    finalAttrs:
    let
      majorVersion = lib.versions.major finalAttrs.version;
    in
    {
      postPatch = finalAttrs.postPatch + ''
        sed 's|/usr/include/libintl.h|${lib.getInclude glibc.dev}/include/libintl.h|' -i wscript
      '';

      buildInputs = generic.buildInputs ++ [
        alsa-lib
        dbus
        libpulseaudio
        libxi
        libxinerama
        libxrandr
      ];

      wafConfigureFlags = finalAttrs.wafConfigureFlags ++ [ "--freedesktop" ];
      env.NIX_CFLAGS_COMPILE = finalAttrs.env.NIX_CFLAGS_COMPILE + "-D_GNU_SOURCE";

      postInstall =
        finalAttrs.postInstall
        + ''
          # wscript does not install these for some reason
          install -vDm 644 "build/gtk2_ardour/ardour.xml" \
            -t "$out/share/mime/packages"
          install -vDm 644 "build/gtk2_ardour/ardour${majorVersion}.desktop" \
            -t "$out/share/applications"
          for size in 16 22 32 48 256 512; do
            install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
              "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour${majorVersion}.png"
          done

          # install additional bundled beats, chords and progressions
          cp -rp "${bundledContent}"/* "$out/share/ardour${majorVersion}/media"
        ''
        + lib.optionalString videoSupport ''
          # `harvid` and `xjadeo` must be accessible in `PATH` for video to work.
          wrapProgram "$out/bin/ardour${majorVersion}" \
            --prefix PATH : "${lib.makeBinPath videoInputs}"
        '';
    }
  );

  darwin' = generic.overrideAttrs (
    finalAttrs:
    let
      majorVersion = lib.versions.major finalAttrs.version;
    in
    {
      patches = finalAttrs.patches ++ [
        (fetchpatch {
          # TODO: Remove with the next release of Ardour
          url = "https://github.com/Ardour/ardour/commit/bff1ebbca2f50f1a0d2285efcf6e0c8237a07d8f.diff";
          hash = "sha256-Ye22S2bmRt+c/GrrvgWCDlzUqSwaOdAh5vFuJb/BqV8=";
          name = "fix-path-to-mo-files.diff";
        })
      ];

      postPatch = finalAttrs.postPatch + ''
        substituteInPlace wscript \
          --replace-fail '-DMAC_OS_X_VERSION_MAX_ALLOWED=110000' '-DMAC_OS_X_VERSION_MAX_ALLOWED=140000' \
          --replace-fail '-mmacosx-version-min=11.0' '-mmacosx-version-min=14'

        substituteInPlace libs/tk/y{d,t}k/wscript \
          --replace-fail "'-xobjective-c'" "'-xobjective-c', '-DDISABLE_VISIBILITY'"

        substituteInPlace tools/osx_packaging/osx_build \
          --replace-fail 'WITH_HARRISON_LV2=1' 'WITH_HARRISON_LV2=' \
          --replace-fail 'WITH_GMSYNTH=1' 'WITH_GMSYNTH=' \
          --replace-fail 'WITH_HARVID=1' 'WITH_HARVID=' \
          --replace-fail 'WITH_XJADEO=1' 'WITH_XJADEO=' \
          --replace-fail '`hostname`' 'localhost' \
          --replace-fail '`whoami`' 'nixbld' \
          --replace-fail '../../build' "$PWD/build" \
          --replace-fail 'echo "Building DMG ..."' 'exit 0'
      '';

      nativeBuildInputs = finalAttrs.nativeBuildInputs ++ [
        darwin.DarwinTools
        fixDarwinDylibNames
        which
        writableTmpDirAsHomeHook
      ];

      buildInputs = finalAttrs.buildInputs ++ [
        apple-sdk
      ];

      wafBuildTargets = [
        "build"
        "i18n"
      ];

      wafConfigureFlags = finalAttrs.wafConfigureFlags ++ [ "--with-backends=coreaudio,jack,dummy" ];

      postBuild = ''
        # NOTE: The .so files are symlinks to the actual .dylib files.
        install_name_tool \
          -change libvamp-sdk.so "${lib.getLib vamp-plugin-sdk}/lib/libvamp-sdk.so" \
          -change libvamp-hostsdk.so "${lib.getLib vamp-plugin-sdk}/lib/libvamp-hostsdk.so" \
          "build/gtk2_ardour/ardour-${finalAttrs.version}.0"

        (
        cd tools/osx_packaging
        ./osx_build --public
        )
      '';

      preCheck = ''
        # NOTE: The .so files are symlinks to the actual .dylib files.
        install_name_tool \
          -change libvamp-sdk.so "${lib.getLib vamp-plugin-sdk}/lib/libvamp-sdk.so" \
          -change libvamp-hostsdk.so "${lib.getLib vamp-plugin-sdk}/lib/libvamp-hostsdk.so" \
          "build/libs/audiographer/run-tests"
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"/{Applications,bin}
        mv "tools/osx_packaging/Ardour/Ardour${majorVersion}.app/" "$out/Applications/"
        ln -s "$out/Applications/Ardour${majorVersion}.app/Contents/MacOS/Ardour${majorVersion}" \
          "$out/bin/ardour${majorVersion}"

        # install additional bundled beats, chords and progressions
        cp -rp "${bundledContent}"/* "$out/Applications/Ardour${majorVersion}.app/Contents/Resources/media"

        runHook postInstall
      '';
    }
  );
in
if stdenv.hostPlatform.isLinux then linux else darwin'
