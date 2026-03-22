{
  lib,
  callPackage,
  stdenv,
  stdenvNoCC,
  fetchgit,
  fetchzip,
  alsa-lib,
  apple-sdk,
  aubio,
  boost,
  cairomm,
  cppunit,
  curl,
  curlMinimal,
  darwin,
  dbus,
  doxygen,
  ffmpeg,
  fftw,
  fftwSinglePrec,
  file,
  flac,
  fluidsynth,
  glibc,
  glibmm,
  graphviz,
  harvid,
  hidapi,
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
  python311,
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
  xjadeo,
  libxrandr,
  libxinerama,
  optimize ? true, # disable to print Lua DSP script output to stdout
  videoSupport ? true,
}:
let
  version = "9.2";
  majorVersion = lib.versions.major version;
  isDarwin = stdenv.isDarwin;

  darwinLv2Stack = if isDarwin then callPackage ./ardour-lv2-stack.nix { } else null;
  aubioForArdour = if isDarwin then callPackage ./aubio-darwin.nix { } else aubio;
  curlForArdour = if isDarwin then curlMinimal else curl;
  libwebsocketsForArdour =
    if isDarwin then callPackage ./libwebsockets-darwin.nix { } else libwebsockets;
  lilvForArdour = if isDarwin then darwinLv2Stack.lilv else lilv;
  lv2ForArdour = if isDarwin then darwinLv2Stack.lv2 else lv2;
  serdForArdour = if isDarwin then darwinLv2Stack.serd else serd;
  sordForArdour = if isDarwin then darwinLv2Stack.sord else sord;
  sratomForArdour = if isDarwin then darwinLv2Stack.sratom else sratom;
  vampPluginSdkForArdour =
    if isDarwin then callPackage ./vamp-plugin-sdk-darwin.nix { } else vamp-plugin-sdk;

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = version;
    hash = "sha256-zbEfEuWdhlKtYE0gVB/N0dFrcmNoJqgEMuvQ0wdmRpM=";
  };

  bundledContent = fetchzip {
    url = "https://web.archive.org/web/20221026200824/http://stuff.ardour.org/loops/ArdourBundledMedia.zip";
    hash = "sha256-IbPQWFeyMuvCoghFl1ZwZNNcSvLNsH84rGArXnw+t7A=";
    stripRoot = false;
  };

  commonPatches = [
    ./as-flags.patch
    ./default-plugin-search-paths.patch
  ] ++ lib.optional isDarwin ./arm64-fix.patch;

  commonPostPatch =
    ''
      printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "${version}"; const char* date = ""; }\n' > libs/ardour/revision.cc
    ''
    + lib.optionalString (!isDarwin) ''
      sed 's|/usr/include/libintl.h|${glibc.dev}/include/libintl.h|' -i wscript
    ''
    + ''
      patchShebangs ./tools/
      substituteInPlace libs/ardour/video_tools_paths.cc \
        --replace-fail 'ffmpeg_exe = X_("");' 'ffmpeg_exe = X_("${ffmpeg}/bin/ffmpeg");' \
        --replace-fail 'ffprobe_exe = X_("");' 'ffprobe_exe = X_("${ffmpeg}/bin/ffprobe");'
    ''
    + lib.optionalString isDarwin ''
      substituteInPlace wscript \
        --replace "rev, rev_date = fetch_tarball_revision_date()" "rev, rev_date = '${version}', 'unknown'" \
        --replace "rev, rev_date = fetch_git_revision_date()" "rev, rev_date = '${version}', 'unknown'"
      chmod +x waf
    '';

  commonMeta = {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Ardour is a digital audio workstation (DAW), You can use it to
      record, edit and mix multi-track audio and midi. Produce your
      own CDs. Mix video soundtracks. Experiment with new ideas about
      music and sound.

      Please consider supporting the ardour project financially:
      https://community.ardour.org/donate
    '';
    homepage = "https://ardour.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ardour${majorVersion}";
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [
      magnetophon
      mitchmindtree
      ryand56
    ];
  };

  linuxArdour = stdenv.mkDerivation {
    pname = "ardour";
    inherit version src;

    patches = commonPatches;
    postPatch = commonPostPatch;

    nativeBuildInputs = [
      doxygen
      graphviz
      itstool
      makeWrapper
      perl
      pkg-config
      python3
      wafHook
    ];

    buildInputs = [
      alsa-lib
      aubioForArdour
      boost
      cairomm
      cppunit
      curlForArdour
      dbus
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
      liblo
      libltc
      libogg
      libpulseaudio
      librdf_rasqal
      libsamplerate
      libsigcxx
      libsndfile
      libusb1
      libuv
      libwebsocketsForArdour
      libxi
      libxml2
      libxslt
      lilvForArdour
      lrdf
      lv2ForArdour
      pango
      pangomm
      perl
      python3
      qm-dsp
      readline
      rubberband
      serdForArdour
      sordForArdour
      soundtouch
      sratomForArdour
      suil
      taglib
      vampPluginSdkForArdour
      libxinerama
      libxrandr
    ]
    ++ lib.optionals videoSupport [
      harvid
      xjadeo
    ];

    wafConfigureFlags = [
      "--cxx17"
      "--docs"
      "--freedesktop"
      "--no-phone-home"
      "--ptformat"
      "--run-tests"
      "--test"
      # since we don't have https://github.com/agfline/LibAAF yet,
      # we need to use some of ardours internal libs, see:
      # https://discourse.ardour.org/t/ardour-8-2-released/109615/6
      # and
      # https://discourse.ardour.org/t/ardour-8-2-released/109615/8
      # "--use-external-libs"
    ]
    ++ lib.optional optimize "--optimize";

    env = {
      NIX_CFLAGS_COMPILE = toString [
        "-D_GNU_SOURCE"
        "-I${lib.getDev serdForArdour}/include/serd-0"
        "-I${lib.getDev sratomForArdour}/include/sratom-0"
        "-I${lib.getDev sordForArdour}/include/sord-0"
      ];
      LINKFLAGS = "-lpthread";
    };

    postInstall =
      ''
        install -vDm 644 "build/gtk2_ardour/ardour.xml" \
          -t "$out/share/mime/packages"
        install -vDm 644 "build/gtk2_ardour/ardour${majorVersion}.desktop" \
          -t "$out/share/applications"
        for size in 16 22 32 48 256 512; do
          install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour${majorVersion}.png"
        done
        install -vDm 644 "ardour.1"* -t "$out/share/man/man1"

        mkdir -p "$out/share/ardour${majorVersion}/media"
        cp -rp ${bundledContent}/. "$out/share/ardour${majorVersion}/media"
      ''
      + lib.optionalString videoSupport ''
        wrapProgram "$out/bin/ardour${majorVersion}" \
          --prefix PATH : "${
            lib.makeBinPath [
              harvid
              xjadeo
            ]
          }"
      '';

    meta = commonMeta;
  };

  darwinArdourBase = stdenv.mkDerivation {
    pname = "ardour-unwrapped";
    inherit version src;

    patches = commonPatches;
    postPatch = commonPostPatch;

    nativeBuildInputs = [
      itstool
      perl
      pkg-config
      python311
    ];

    buildInputs = [
      apple-sdk
      aubioForArdour
      boost
      cairomm
      cppunit
      curlForArdour
      ffmpeg
      fftw
      fftwSinglePrec
      flac
      fluidsynth
      glibmm
      hidapi
      kissfft
      libarchive
      libjack2
      liblo
      libltc
      libogg
      librdf_rasqal
      libsamplerate
      libsigcxx
      libsndfile
      libusb1
      libuv
      libwebsocketsForArdour
      libxml2
      libxslt
      lilvForArdour
      lrdf
      lv2ForArdour
      pango
      pangomm
      perl
      python311
      qm-dsp
      readline
      rubberband
      serdForArdour
      sordForArdour
      soundtouch
      sratomForArdour
      suil
      taglib
      vampPluginSdkForArdour
    ];

    CFLAGS = "-DDISABLE_VISIBILITY";
    CXXFLAGS = "-DDISABLE_VISIBILITY";

    preConfigure = ''
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags sratom-0) $NIX_CFLAGS_COMPILE"
    '';

    configurePhase = ''
      runHook preConfigure
      python3 ./waf configure \
        --prefix="$out" \
        --strict \
        --ptformat \
        --libjack=weak \
        --keepflags \
        ${lib.optionalString stdenv.hostPlatform.isAarch64 "--arm64"} \
        ${lib.optionalString optimize "--optimize"}
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      python3 ./waf
      python3 ./waf i18n
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      python3 ./waf install

      if [ -f build/libs/clearlooks-newer/libclearlooks.dylib ]; then
        mkdir -p "$out/lib/ardour${majorVersion}/gtkengines/engines"
        cp build/libs/clearlooks-newer/libclearlooks.dylib \
          "$out/lib/ardour${majorVersion}/gtkengines/libclearlooks.dylib"
        ln -sf ../libclearlooks.dylib \
          "$out/lib/ardour${majorVersion}/gtkengines/engines/libclearlooks.so"
      fi

      runHook postInstall
    '';

    meta = commonMeta;
  };

  darwinArdour = stdenvNoCC.mkDerivation {
    pname = "ardour";
    inherit version;

    dontUnpack = true;
    dontPatchShebangs = true;

    nativeBuildInputs = [
      darwin.cctools
      file
      makeWrapper
      python3
    ];

    installPhase = ''
      runHook preInstall

      cp -a ${darwinArdourBase}/. "$out/"
      chmod -R u+w "$out"

      ardourLib="$out/lib/ardour${majorVersion}"
      baseRoot="${darwinArdourBase}"
      buildPrefix="/source/build/libs/"
      bundledLibDir="$ardourLib/bundled"

      if [ -d "$ardourLib" ]; then
        mkdir -p "$bundledLibDir"
        export ardourLib bundledLibDir out

        python3 ${./copy-tree-macho-deps.py}

        while IFS= read -r -d "" macho; do
          if ! file -b "$macho" | grep -q "Mach-O"; then
            continue
          fi

          machoDir="$(dirname "$macho")"

          case "$macho" in
            *.dylib)
              install_name_tool -id "@loader_path/$(basename "$macho")" "$macho"
              ;;
          esac

          while IFS= read -r dep; do
            target=""

            case "$dep" in
              "$baseRoot"/*)
                target="$out/''${dep#"$baseRoot"/}"
                ;;
              "$out"/*)
                target="$dep"
                ;;
              /nix/store/*)
                depBase="$(basename "$dep")"
                if [ -f "$bundledLibDir/$depBase" ]; then
                  target="$bundledLibDir/$depBase"
                fi
                ;;
              *"$buildPrefix"*)
                depBase="$(basename "$dep")"
                target="$(find -L "$ardourLib" -name "$depBase" | head -n 1)"
                ;;
            esac

            if [ -n "$target" ]; then
              relTarget="$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$target" "$machoDir")"
              install_name_tool -change "$dep" "@loader_path/$relTarget" "$macho"
            elif [ "''${dep#"$baseRoot"/}" != "$dep" ] || [ "''${dep#"$buildPrefix"}" != "$dep" ]; then
              echo "warning: no installed Mach-O match for $dep in $macho" >&2
            fi
          done < <(otool -L "$macho" | tail -n +2 | awk '{print $1}')
        done < <(find "$ardourLib" -type f \( -perm -111 -o -name "*.dylib" \) -print0)
      fi

      if [ -d "$out/share/ardour${majorVersion}/media" ]; then
        cp -rp ${bundledContent}/. "$out/share/ardour${majorVersion}/media"
      fi

      if [ -d "$out/lib/ardour${majorVersion}/LV2" ]; then
        while IFS= read -r -d "" ttl; do
          bundleName="$(basename "$(dirname "$ttl")")"
          installDir="$out/lib/ardour${majorVersion}/LV2/$bundleName"
          mkdir -p "$installDir"
          cp "$ttl" "$installDir/"
        done < <(find ${darwinLv2Stack.lv2}/lib/lv2 -mindepth 2 -maxdepth 2 -type f -name "*.ttl" -print0)
      fi

      for script in \
        "$out/bin/ardour${majorVersion}" \
        "$out/bin/ardour${majorVersion}-lua" \
        "$out/bin/ardour${majorVersion}-export" \
        "$out/bin/ardour${majorVersion}-new_session" \
        "$out/bin/ardour${majorVersion}-new_empty_session" \
        "$out/lib/ardour${majorVersion}/utils/ardour-util.sh"
      do
        [ -f "$script" ] || continue

        substituteInPlace "$script" \
          --replace "${darwinArdourBase}/share/ardour${majorVersion}" '$_ardour_root/share/ardour${majorVersion}' \
          --replace "${darwinArdourBase}/etc/ardour${majorVersion}" '$_ardour_root/etc/ardour${majorVersion}' \
          --replace "${darwinArdourBase}/lib/ardour${majorVersion}" '$_ardour_root/lib/ardour${majorVersion}'
      done

      for script in \
        "$out/bin/ardour${majorVersion}" \
        "$out/bin/ardour${majorVersion}-lua" \
        "$out/bin/ardour${majorVersion}-export" \
        "$out/bin/ardour${majorVersion}-new_session" \
        "$out/bin/ardour${majorVersion}-new_empty_session"
      do
        [ -f "$script" ] || continue

        tmp="$TMPDIR/$(basename "$script").wrapped"
        {
          printf '%s\n' '#!/bin/sh'
          printf '%s\n' '_script_dir="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"'
          printf '%s\n' '_ardour_root="$(CDPATH= cd -- "$_script_dir/.." && pwd)"'
          sed '1d' "$script"
        } > "$tmp"
        mv "$tmp" "$script"
        chmod +x "$script"
      done

      if [ -f "$out/lib/ardour${majorVersion}/utils/ardour-util.sh" ]; then
        tmp="$TMPDIR/ardour-util.sh.wrapped"
        {
          printf '%s\n' '#!/bin/sh'
          printf '%s\n' '_script_dir="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"'
          printf '%s\n' '_ardour_root="$(CDPATH= cd -- "$_script_dir/../../.." && pwd)"'
          sed '1d' "$out/lib/ardour${majorVersion}/utils/ardour-util.sh"
        } > "$tmp"
        mv "$tmp" "$out/lib/ardour${majorVersion}/utils/ardour-util.sh"
        chmod +x "$out/lib/ardour${majorVersion}/utils/ardour-util.sh"
      fi

      ${lib.optionalString videoSupport ''
        wrapProgram "$out/bin/ardour${majorVersion}" \
          --prefix PATH : "${lib.makeBinPath [ harvid ]}"
      ''}

      runHook postInstall
    '';

    passthru = {
      unwrapped = darwinArdourBase;
    };

    meta = commonMeta;
  };
in
if isDarwin then darwinArdour else linuxArdour
