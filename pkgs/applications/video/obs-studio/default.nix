{
  config,
  uthash,
  lib,
  stdenv,
  stdenvNoCC,
  ninja,
  nv-codec-headers-12,
  fetchFromGitHub,
  fetchurl,
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
  cmake,
  fdk_aac,
  ffmpeg,
  jansson,
  libjack2,
  libxkbcommon,
  libpthread-stubs,
  libxdmcp,
  qt6,
  speex,
  libv4l,
  x264,
  curl,
  wayland,
  libx11,
  pkg-config,
  libvlc,
  libGL,
  mbedtls,
  wrapGAppsHook3,
  scriptingSupport ? true,
  luajit,
  swig,
  python3,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  browserSupport ? true,
  cef-binary,
  pciutils,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  withFdk ? true,
  pipewire,
  libdrm,
  librist,
  cjson,
  libva,
  srt,
  nlohmann_json,
  websocketpp,
  asio,
  decklinkSupport ? false,
  blackmagic-desktop-video,
  libdatachannel,
  libvpl,
  qrcodegencpp,
  simde,
  nix-update-script,
  kdePackages,
  apple-sdk_26,
  darwinMinVersionHook,
  swift,
  rnnoise,
  freetype,
  libiconv,
  makeBinaryWrapper,
  darwin,
}:

let
  inherit (lib) optional optionals;
  inherit (stdenv.hostPlatform) isDarwin isLinux;

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  cef = if isDarwin then darwinCef else linuxCef;

  # OBS's build of CEF for macOS, with the version, revision and hash its
  # CMakePresets.json has.
  darwinCef = stdenvNoCC.mkDerivation {
    pname = "obs-studio-cef";
    version = "6533-5";

    src = fetchurl {
      url = "https://cdn-fastly.obsproject.com/downloads/cef_binary_6533_macos_arm64_v5.tar.xz";
      hash = "sha256-QptQ509sF03P4vFNggS1St1Jfqr+EX97ac5rsjVNJiY=";
    };

    # Its files are at the top of the archive.
    unpackPhase = ''
      runHook preUnpack
      mkdir cef
      tar -xf $src -C cef
      cd cef
      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;
    # Signed as it comes.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      cp -R . $out
      runHook postInstall
    '';

    passthru.buildType = "Release";
  };

  linuxCef = cef-binary.overrideAttrs (
    oldAttrs:
    let
      version = "6533";
      revision = "6";
    in
    {
      inherit version;

      src = fetchurl {
        url = "https://cdn-fastly.obsproject.com/downloads/cef_binary_${version}_linux_${
          selectSystem {
            aarch64-linux = "aarch64";
            x86_64-linux = "x86_64";
          }
        }_v${revision}.tar.xz";
        hash = selectSystem {
          aarch64-linux = "sha256-ZCUURp6qKaXIh4kQhNLnP33C10Bfffp3JrLbwkswmZk=";
          x86_64-linux = "sha256-eWMzVRmhnM3FIz9zNMWrAjAm4vPpoMxBcAfAnYZggUY=";
        };
      };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "32.2.2";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    tag = finalAttrs.version;
    hash = "sha256-JAV3UvM89asUj6P5pD9a+6/Qfa2kFIVQqVfMOZn5MJE=";
    fetchSubmodules = true;
  };

  separateDebugInfo = isLinux;

  patches = [
    ./fix-nix-plugin-path.patch
  ]
  # Ninja rather than Xcode, see the patch.
  ++ optional isDarwin ./darwin-ninja.patch;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ optionals isLinux [
    addDriverRunpath
    wrapGAppsHook3
    kdePackages.extra-cmake-modules
  ]
  ++ optionals isDarwin [
    swift
    makeBinaryWrapper
    darwin.autoSignDarwinBinariesHook
  ]
  ++ optional scriptingSupport swig
  ++ optional cudaSupport autoAddDriverRunpath;

  buildInputs = [
    curl
    ffmpeg
    jansson
    qt6.qtbase
    qt6.qtsvg
    speex
    x264
    mbedtls
    librist
    cjson
    srt
    nlohmann_json
    websocketpp
    asio
    libdatachannel
    qrcodegencpp
    uthash
  ]
  ++ optionals isLinux [
    libjack2
    libv4l
    libxkbcommon
    libpthread-stubs
    libxdmcp
    wayland
    libvlc
    pciutils
    libva
    qt6.qtwayland
    libvpl
    nv-codec-headers-12
  ]
  ++ optionals isDarwin [
    # OBS 32.2 wants at least the macOS 26.5 SDK, and runs on macOS 13 and
    # later.
    apple-sdk_26
    (darwinMinVersionHook "13.0")
    rnnoise
    freetype
    libiconv
  ]
  ++ optionals scriptingSupport ([ luajit ] ++ optional isLinux python3)
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optionals pipewireSupport [
    pipewire
    libdrm
  ]
  ++ optional browserSupport cef
  ++ optional withFdk fdk_aac;

  propagatedBuildInputs = [ simde ];

  # Copied from the obs-linuxbrowser
  postUnpack = lib.optionalString browserSupport ''
    ln -s ${cef} cef
  '';

  postPatch = ''
    cp ${./CMakeUserPresets.json} ./CMakeUserPresets.json
  '';

  # clang and swiftc cache the SDK's modules (mac-avcapture's @import) in the
  # user's cache directory, which a sandbox withholds, and then under $HOME.
  preConfigure = lib.optionalString isDarwin ''
    export HOME=$(mktemp -d)
  '';

  cmakeFlags = [
    "--preset"
    "nixpkgs-${if stdenv.hostPlatform.isDarwin then "darwin" else "linux"}"
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    (lib.cmakeBool "ENABLE_JACK" isLinux)
    "-DENABLE_WEBRTC=ON"
    (lib.cmakeBool "ENABLE_QSV11" (isLinux && stdenv.hostPlatform.isx86_64))
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_SCRIPTING" scriptingSupport)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false) # TODO: fix linking against libajantv2
    (lib.cmakeBool "ENABLE_BROWSER" browserSupport)
  ]
  ++ optionals isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    "-DCMAKE_Swift_COMPILER=${lib.getExe' swift "swiftc"}"
    # Swift's own clang, first in PATH, fails to build the SDK's modules
    # (@import AVFoundation in mac-avcapture): the rest builds with the
    # stdenv's.
    "-DCMAKE_C_COMPILER=${stdenv.cc}/bin/clang"
    "-DCMAKE_CXX_COMPILER=${stdenv.cc}/bin/clang++"
    "-DCMAKE_OBJC_COMPILER=${stdenv.cc}/bin/clang"
    "-DCMAKE_OBJCXX_COMPILER=${stdenv.cc}/bin/clang++"
    # Newer compilers than OBS's warn of more.
    (lib.cmakeBool "CMAKE_COMPILE_WARNING_AS_ERROR" false)
    # Without Sparkle's updates, as Nix updates it.
    "-DSPARKLE_APPCAST_URL="
    "-DSPARKLE_PUBLIC_KEY="
    # The virtual camera is a system extension, which needs signing by a team.
    (lib.cmakeBool "ENABLE_VIRTUALCAM" false)
    # Syphon's framework and VLC are not packaged for macOS.
    (lib.cmakeBool "ENABLE_SYPHON" false)
    (lib.cmakeBool "ENABLE_VLC" false)
    # On macOS, OBS loads Python 3.8 to 3.11 from where the user points it.
    (lib.cmakeBool "ENABLE_SCRIPTING_PYTHON" false)
  ]
  ++ lib.optional browserSupport "-DCEF_ROOT_DIR=../../cef";

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=sign-compare" # https://github.com/obsproject/obs-studio/issues/10200
    ]
    ++ optional isLinux "-Wno-error=stringop-overflow="
  );

  # What Xcode embeds in the bundle, which Ninja leaves in the build tree:
  # OBS's frameworks and libraries, its plugins and Lua's module (which it
  # looks for with the plugins), and CEF with its helpers. The install names
  # that point into the build tree then go through the bundle's rpaths, and
  # the Info.plist gets what Xcode would generate, the microphone's and the
  # camera's usage among it. Qt's plugins go with OBS's, where the bundle's
  # qt.conf has Qt look for them.
  postInstall = lib.optionalString isDarwin (
    ''
      app=$out/Applications/OBS.app
      contents=$app/Contents
      mkdir -p $out/Applications
      mv $out/OBS.app $app
      mkdir -p $contents/Frameworks $contents/PlugIns

      cp -R libobs/libobs.framework $contents/Frameworks/
      for library in frontend/api/obs-frontend-api.dylib libobs-opengl/libobs-opengl.dylib \
          libobs-metal/libobs-metal.dylib shared/obs-scripting/obs-scripting.dylib; do
        if [ -e $library ]; then cp $library $contents/Frameworks/; fi
      done
      find . -path ./frontend/OBS.app -prune -o -name '*.plugin' -type d -prune -print \
        | while read -r plugin; do cp -R "$plugin" $contents/PlugIns/; done
      if [ -e shared/obs-scripting/obslua/obslua.so ]; then
        cp shared/obs-scripting/obslua/obslua.so $contents/PlugIns/
      fi
      for plugins in ${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix} ${qt6.qtsvg}/${qt6.qtbase.qtPluginPrefix}; do
        for category in $plugins/*; do
          mkdir -p $contents/PlugIns/''${category##*/}
          ln -s $category/* $contents/PlugIns/''${category##*/}/
        done
      done
    ''
    + lib.optionalString browserSupport ''
      ln -s "${cef}/${cef.buildType}/Chromium Embedded Framework.framework" $contents/Frameworks/
      find plugins/obs-browser -maxdepth 1 -name 'OBS Helper*.app' -type d \
        | while read -r helper; do cp -R "$helper" $contents/Frameworks/; done
    ''
    + ''
      relink() {
        local binary=$1 rpath=$2 dependency name old
        while read -r dependency; do
          case $dependency in
            /usr/lib/* | /System/* | @* | $NIX_STORE/*) continue ;;
          esac
          if [[ $dependency =~ ([^/]+\.framework/.+)$ ]]; then
            name=''${BASH_REMATCH[1]}
          else
            name=''${dependency##*/}
          fi
          install_name_tool -change "$dependency" "@rpath/$name" "$binary"
        done < <(otool -L "$binary" | tail -n +2 | awk '{ print $1 }')
        while read -r old; do
          case $old in
            @* | $NIX_STORE/*) ;;
            *) install_name_tool -delete_rpath "$old" "$binary" ;;
          esac
        done < <(otool -l "$binary" | awk '$1 == "cmd" && $2 == "LC_RPATH" { getline; getline; print $2 }')
        if ! otool -l "$binary" | grep -qF "path $rpath "; then
          install_name_tool -add_rpath "$rpath" "$binary"
        fi
      }

      for library in $contents/Frameworks/*.dylib; do
        install_name_tool -id "@rpath/''${library##*/}" "$library"
        relink "$library" @loader_path
      done
      libobs=$contents/Frameworks/libobs.framework/Versions/A/libobs
      install_name_tool -id @rpath/libobs.framework/Versions/A/libobs $libobs
      relink $libobs @loader_path/../../..
      for binary in $contents/MacOS/*; do
        relink "$binary" @executable_path/../Frameworks
      done
      for binary in $contents/PlugIns/*.plugin/Contents/MacOS/*; do
        relink "$binary" @loader_path/../../../../Frameworks
      done
      if [ -e $contents/PlugIns/obslua.so ]; then
        relink $contents/PlugIns/obslua.so @loader_path/../Frameworks
      fi
      for binary in $contents/Frameworks/OBS\ Helper*.app/Contents/MacOS/*; do
        if [ -e "$binary" ]; then relink "$binary" @executable_path/../../..; fi
      done

      # Plugins built for OBS's own app, which has Qt in its Frameworks, link
      # Qt through the rpath: these lead them to the Qt OBS itself loads.
      for binary in $contents/MacOS/OBS $libobs; do
        install_name_tool -add_rpath ${qt6.qtbase}/lib -add_rpath ${qt6.qtsvg}/lib "$binary"
      done

      cp ../cmake/macos/resources/AppIcon.icns $contents/Resources/
      cat > $contents/Info.plist <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key><string>en</string>
        <key>CFBundleDisplayName</key><string>OBS Studio</string>
        <key>CFBundleExecutable</key><string>OBS</string>
        <key>CFBundleIconFile</key><string>AppIcon</string>
        <key>CFBundleIdentifier</key><string>com.obsproject.obs-studio</string>
        <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
        <key>CFBundleName</key><string>OBS</string>
        <key>CFBundlePackageType</key><string>APPL</string>
        <key>CFBundleShortVersionString</key><string>${finalAttrs.version}</string>
        <key>CFBundleVersion</key><string>${finalAttrs.version}</string>
        <key>LSMinimumSystemVersion</key><string>13.0</string>
        <key>LSAppNapIsDisabled</key><true/>
        <key>NSHighResolutionCapable</key><true/>
        <key>NSPrincipalClass</key><string>NSApplication</string>
        <key>NSCameraReactionEffectGesturesEnabledDefault</key><false/>
        <key>NSCameraUsageDescription</key><string>OBS needs to access the camera to enable camera sources to work.</string>
        <key>NSMicrophoneUsageDescription</key><string>OBS needs to access the microphone to enable audio input.</string>
        <key>NSAppleEventsUsageDescription</key><string>OBS needs to access background events to enable hotkeys while not in focus.</string>
      </dict>
      </plist>
      EOF

      # From the bundle, where OBS looks for its frameworks and plugins.
      makeBinaryWrapper $contents/MacOS/OBS $out/bin/obs

      # libobs and obs-frontend-api to build plugins with, outside the bundle,
      # named as in it, where the plugins then find them.
      cmake --install . --component Development --prefix $out
      install_name_tool -id @rpath/libobs.framework/Versions/A/libobs \
        $out/Frameworks/libobs.framework/Versions/A/libobs
      install_name_tool -id @rpath/obs-frontend-api.dylib $out/lib/obs-frontend-api.dylib
      relink $out/lib/obs-frontend-api.dylib @loader_path
    ''
  );

  dontWrapQtApps = isDarwin;
  dontWrapGApps = true;
  preFixup = lib.optionalString isLinux (
    let
      wrapperLibraries = [
        libx11
        libvlc
        libGL
      ]
      ++ optionals decklinkSupport [ blackmagic-desktop-video ];
    in
    ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
        ''${gappsWrapperArgs[@]}
      )
    ''
    + lib.optionalString browserSupport ''
      # Remove cef components before patchelf, otherwise it will fail
      rm $out/lib/obs-plugins/libcef.so
      rm $out/lib/obs-plugins/libEGL.so
      rm $out/lib/obs-plugins/libGLESv2.so
      rm $out/lib/obs-plugins/libvk_swiftshader.so
      rm $out/lib/obs-plugins/libvulkan.so.1
      rm $out/lib/obs-plugins/chrome-sandbox
    ''
  );

  postFixup = lib.optionalString isLinux (
    lib.concatStrings [
      ''
        addDriverRunpath $out/lib/lib*.so
        addDriverRunpath $out/lib/obs-plugins/*.so
      ''

      (lib.optionalString browserSupport ''
        # Link cef components again after patchelfing other libs
        ln -sf ${cef}/${cef.buildType}/* $out/lib/obs-plugins/
      '')
    ]
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    changelog = "https://github.com/obsproject/obs-studio/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      jb55
      materus
      fpletz
    ];
    license = with lib.licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "obs";
  };
})
