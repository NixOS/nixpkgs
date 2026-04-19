{
  lib,
  stdenv,
  perl,
  swift,
  swiftpm,
  luajit,
  python311,
  freetype,
  fontconfig,
  libiconv,
  rnnoise,
  srt,
  mkObsCefPackage,
  browserSupport ? true,
  scriptingSupport ? true,
}:

let
  inherit (lib) optionals;

  cef = mkObsCefPackage {
    version = "6533";
    revision = "5";
    platformMap = {
      aarch64-darwin = "macos_arm64";
      x86_64-darwin = "macos_x86_64";
    };
    hashes = {
      aarch64-darwin = "sha256-QptQ509sF03P4vFNggS1St1Jfqr+EX97ac5rsjVNJiY=";
      x86_64-darwin = "sha256-N791caSMXfqFGYF+SpCjUDoOsw+erdavTz54PjY/Jyo=";
    };
  };
in
{
  preset = "nixpkgs-darwin";

  inherit cef;

  patches = [
    ./darwin-source-fixes.patch
  ];

  extraNativeBuildInputs = [
    perl
    swift
    swiftpm
  ];

  extraBuildInputs = [
    fontconfig
    freetype
    libiconv
    rnnoise
    srt
  ]
  ++ optionals scriptingSupport [
    luajit
    python311
  ];

  postPatch = ''
                substituteInPlace cmake/macos/defaults.cmake \
                  --replace-fail 'include(buildspec)' ""

                # The upstream release pipeline uses the Xcode generator; nixpkgs uses Ninja
                # so the build can run in the sandbox without depending on xcodebuild.
                substituteInPlace cmake/macos/compilerconfig.cmake \
                  --replace-fail 'if(NOT XCODE)' 'if(FALSE)' \
                  --replace-fail 'check_sdk_requirements()' ""

                substituteInPlace CMakeLists.txt \
                  --replace-fail 'project(obs-studio VERSION ''${OBS_VERSION_CANONICAL})' \
                             'project(obs-studio VERSION ''${OBS_VERSION_CANONICAL} LANGUAGES C CXX OBJC OBJCXX Swift)'

                substituteInPlace frontend/CMakeLists.txt \
                  --replace-fail 'add_executable(OBS::studio ALIAS obs-studio)' 'add_executable(OBS::studio ALIAS obs-studio)

        target_link_options(obs-studio PRIVATE LINKER:-headerpad_max_install_names)'

                substituteInPlace frontend/CMakeLists.txt \
                  --replace-fail '        DL_''${graphics_library_U}="$<$<IF:$<PLATFORM_ID:Windows>,TARGET_FILE_NAME,TARGET_SONAME_FILE_NAME>:OBS::libobs-''${graphics_library}>"
    ' '        DL_''${graphics_library_U}="$<$<PLATFORM_ID:Darwin>:@executable_path/../Frameworks/$<TARGET_SONAME_FILE_NAME:OBS::libobs-''${graphics_library}>>$<$<PLATFORM_ID:Windows>:$<TARGET_FILE_NAME:OBS::libobs-''${graphics_library}>>$<$<AND:$<NOT:$<PLATFORM_ID:Windows>>,$<NOT:$<PLATFORM_ID:Darwin>>>:$<TARGET_SONAME_FILE_NAME:OBS::libobs-''${graphics_library}>>"
    '

                substituteInPlace plugins/obs-ffmpeg/ffmpeg-mux/CMakeLists.txt \
                  --replace-fail 'add_executable(OBS::ffmpeg-mux ALIAS obs-ffmpeg-mux)' 'add_executable(OBS::ffmpeg-mux ALIAS obs-ffmpeg-mux)

        target_link_options(obs-ffmpeg-mux PRIVATE LINKER:-headerpad_max_install_names)'

                substituteInPlace libobs-metal/CMakeLists.txt \
                  --replace-fail 'target_link_libraries(libobs-metal PRIVATE OBS::libobs)' 'target_link_libraries(libobs-metal PRIVATE OBS::libobs)

            target_compile_options(
              libobs-metal
              PRIVATE
                "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-import-objc-header ''${CMAKE_CURRENT_SOURCE_DIR}/libobs-metal-Bridging-Header.h>"
                "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fmodules>"
                "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fcxx-modules>"
            )

            set_target_properties(
              libobs-metal
              PROPERTIES
                Swift_LANGUAGE_VERSION 5
                Swift_MODULE_NAME libobs_metal
            )'

                # Upstream relies on Xcode target attributes to turn on Objective-C ARC and
                # modules for the macOS capture plugins. With Ninja we need real compiler
                # flags or @import-based sources fail to compile.
                substituteInPlace plugins/mac-avcapture/CMakeLists.txt \
                  --replace-fail 'target_include_directories(mac-avcapture-legacy PRIVATE legacy)' 'target_include_directories(mac-avcapture-legacy PRIVATE legacy)

            target_compile_options(mac-avcapture-legacy PRIVATE -fobjc-arc)' \
                  --replace-fail 'target_link_libraries(mac-avcapture PRIVATE OBS::libobs)' 'target_link_libraries(mac-avcapture PRIVATE OBS::libobs)

            target_compile_options(mac-avcapture PRIVATE -fobjc-arc -fmodules)'

                substituteInPlace cmake/macos/helpers.cmake \
                  --replace-fail '        COMMAND /bin/ln -fs obs-frontend-api.dylib libobs-frontend-api.1.dylib' '        COMMAND "''${CMAKE_COMMAND}" -E true' \
                  --replace-fail '        WORKING_DIRECTORY "$<TARGET_BUNDLE_CONTENT_DIR:''${target}>/Frameworks"' "" \
                  --replace-fail '        COMMENT "Create symlink for legacy obs-frontend-api"' '        COMMENT "Skip legacy obs-frontend-api symlink for nixpkgs"'

                # OBS enables SWIG's Python stable ABI on Windows and macOS, but we only
                # need the Windows path here; deleting the argument entirely breaks CMake.
                substituteInPlace shared/obs-scripting/obspython/CMakeLists.txt \
                  --replace-fail '$<$<PLATFORM_ID:Windows,Darwin>:-py3-stable-abi>' '$<$<PLATFORM_ID:Windows>:-py3-stable-abi>'
                substituteInPlace shared/obs-scripting/cmake/python.cmake \
                  --replace-fail '$<$<PLATFORM_ID:Windows,Darwin>:-py3-stable-abi>' '$<$<PLATFORM_ID:Windows>:-py3-stable-abi>' \
                  --replace-fail 'target_link_libraries(obs-scripting PRIVATE $<$<PLATFORM_ID:Linux,FreeBSD,OpenBSD>:Python::Python>)' 'target_link_libraries(obs-scripting PRIVATE $<$<PLATFORM_ID:Linux,FreeBSD,OpenBSD,Darwin>:Python::Python>)' \
                  --replace-fail 'target_link_options(obs-scripting PRIVATE $<$<PLATFORM_ID:Darwin>:LINKER:-undefined,dynamic_lookup>)' ""
  '';

  # curl 8's header-side typechecker rejects several legacy OBS call sites.
  nixCflagsCompile = [ "-DCURL_DISABLE_TYPECHECK" ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    "-DCMAKE_Swift_COMPILER=${swift}/bin/swiftc"
    "-DOBS_CODESIGN_IDENTITY=-"
    "-DPython_ROOT_DIR=${python311}"
    "-DPython_EXECUTABLE=${python311.interpreter}"
    "-DSPARKLE_APPCAST_URL=" # Disabling Sparkle, Nix can handle updating
    "-DSPARKLE_PUBLIC_KEY="
    "-DENABLE_AJA=OFF" # Not really a thing on Darwin anyways
    "-DENABLE_DECKLINK=OFF"
    "-DENABLE_QSV11=OFF"
    "-DENABLE_SYPHON=OFF"
    "-DENABLE_VIRTUALCAM=OFF"
    "-DENABLE_VLC=OFF" # LibVLC isn't packaged for Darwin
  ];

  buildPhase = ''
    runHook preBuild
    cmake --build . --parallel
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cmake --install . --prefix "$out/Applications"

    app="$out/Applications/OBS.app"
    frameworks="$app/Contents/Frameworks"
    plugins="$app/Contents/PlugIns"
    macos="$app/Contents/MacOS"
    resources="$app/Contents/Resources"
    plist="$app/Contents/Info.plist"
    script_modules="$resources"

    mkdir -p "$frameworks" "$plugins" "$script_modules"

    rewrite_dep() {
      local binary="$1"
      local old="$2"
      local new="$3"
      install_name_tool -change "$old" "$new" "$binary" 2>/dev/null || true
    }

    set_id() {
      local binary="$1"
      local new_id="$2"
      install_name_tool -id "$new_id" "$binary"
    }

    # Xcode normally embeds these OBS-private libraries into the app bundle.
    # Under Ninja we need to copy them manually and rewrite the wrapped
    # executables away from build-tree-relative install names.
    cp -R libobs/libobs.framework \
       frontend/api/obs-frontend-api.dylib \
       libobs-opengl/libobs-opengl.dylib \
       libobs-metal/libobs-metal.dylib \
       shared/obs-scripting/obs-scripting.dylib \
       "$frameworks/"

    cp shared/obs-scripting/obslua/obslua.so \
       shared/obs-scripting/obspython/_obspython.so \
       "$script_modules/"

    ${lib.optionalString browserSupport ''
      cp -R "${cef}/${cef.buildType}/Chromium Embedded Framework.framework" "$frameworks/"

      while IFS= read -r helper; do
        cp -R "$helper" "$frameworks/"
      done < <(find plugins/obs-browser -maxdepth 1 -name 'OBS Helper*.app' -type d | sort)
    ''}

    while IFS= read -r plugin; do
      cp -R "$plugin" "$plugins/"
    done < <(find plugins frontend/plugins -name '*.plugin' -type d | sort)

    while IFS= read -r binary; do
      rewrite_dep "$binary" \
        "libobs/libobs.framework/Versions/A/libobs" \
        "@loader_path/../../../../Frameworks/libobs.framework/Versions/A/libobs"
      rewrite_dep "$binary" \
        "frontend/api/obs-frontend-api.dylib" \
        "@loader_path/../../../../Frameworks/obs-frontend-api.dylib"
      rewrite_dep "$binary" \
        "shared/obs-scripting/obs-scripting.dylib" \
        "@loader_path/../../../../Frameworks/obs-scripting.dylib"
    done < <(find "$plugins" -path '*/Contents/MacOS/*' -type f | sort)

    set_id "$frameworks/libobs.framework/Versions/A/libobs" "@rpath/libobs.framework/Versions/A/libobs"
    set_id "$frameworks/obs-frontend-api.dylib" "@rpath/obs-frontend-api.dylib"
    set_id "$frameworks/libobs-opengl.dylib" "@rpath/libobs-opengl.dylib"
    set_id "$frameworks/libobs-metal.dylib" "@rpath/libobs-metal.dylib"
    set_id "$frameworks/obs-scripting.dylib" "@rpath/obs-scripting.dylib"

    for binary in \
      "$frameworks/obs-frontend-api.dylib" \
      "$frameworks/libobs-opengl.dylib" \
      "$frameworks/libobs-metal.dylib"; do
      rewrite_dep "$binary" \
        "libobs/libobs.framework/Versions/A/libobs" \
        "@loader_path/libobs.framework/Versions/A/libobs"
    done

    rewrite_dep "$frameworks/obs-scripting.dylib" \
      "libobs/libobs.framework/Versions/A/libobs" \
      "@loader_path/libobs.framework/Versions/A/libobs"
    rewrite_dep "$frameworks/obs-scripting.dylib" \
      "frontend/api/obs-frontend-api.dylib" \
      "@loader_path/obs-frontend-api.dylib"

    for binary in "$script_modules/obslua.so" "$script_modules/_obspython.so"; do
      rewrite_dep "$binary" \
        "libobs/libobs.framework/Versions/A/libobs" \
        "@loader_path/../Frameworks/libobs.framework/Versions/A/libobs"
      rewrite_dep "$binary" \
        "frontend/api/obs-frontend-api.dylib" \
        "@loader_path/../Frameworks/obs-frontend-api.dylib"
      rewrite_dep "$binary" \
        "shared/obs-scripting/obs-scripting.dylib" \
        "@loader_path/../Frameworks/obs-scripting.dylib"
    done

    rewrite_dep "$macos/OBS" \
      "frontend/api/obs-frontend-api.dylib" \
      "@executable_path/../Frameworks/obs-frontend-api.dylib"
    rewrite_dep "$macos/OBS" \
      "libobs/libobs.framework/Versions/A/libobs" \
      "@executable_path/../Frameworks/libobs.framework/Versions/A/libobs"
    rewrite_dep "$macos/obs-ffmpeg-mux" \
      "libobs/libobs.framework/Versions/A/libobs" \
      "@executable_path/../Frameworks/libobs.framework/Versions/A/libobs"

    cp ../cmake/macos/resources/AppIcon.icns "$resources/"
    cp ${./Info.plist} "$plist"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/OBS.app/Contents/MacOS/OBS" "$out/bin/obs"
    runHook postInstall
  '';

  postFixup = ''
    wrapQtApp "$out/Applications/OBS.app/Contents/MacOS/OBS"
  '';

  meta = {
    maintainers = with lib.maintainers; [ philocalyst ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.darwin;
  };
}
