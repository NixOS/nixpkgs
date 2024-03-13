{ pname
, version
, src
, branch
, compat-list

, lib
, stdenv
, cmake
, boost
, pkg-config
, catch2_3
, cpp-jwt
, cryptopp
, enet
, ffmpeg
, fmt
, gamemode
, glslang
, httplib
, inih
, libusb1
, nlohmann_json
, openal
, openssl
, SDL2
, soundtouch
, spirv-tools
, zstd
, vulkan-headers
, vulkan-loader
, enableSdl2Frontend ? true
, enableQt ? true, qtbase, qtmultimedia, qtwayland, wrapQtAppsHook
, enableQtTranslation ? enableQt, qttools
, enableWebService ? true
, enableCubeb ? true, cubeb
, useDiscordRichPresence ? false, rapidjson
}:
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    pkg-config
    ffmpeg
    glslang
  ] ++ lib.optionals enableQt [ wrapQtAppsHook ];

  buildInputs = [
    boost
    catch2_3
    cpp-jwt
    cryptopp
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet
    fmt
    httplib
    inih
    libusb1
    nlohmann_json
    openal
    openssl
    SDL2
    soundtouch
    spirv-tools
    vulkan-headers
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zstd
  ] ++ lib.optionals enableQt [ qtbase qtmultimedia qtwayland ]
    ++ lib.optional enableQtTranslation qttools
    ++ lib.optional enableCubeb cubeb
    ++ lib.optional useDiscordRichPresence rapidjson;

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_LIBS" true)

    (lib.cmakeBool "DISABLE_SYSTEM_DYNARMIC" true)
    (lib.cmakeBool "DISABLE_SYSTEM_GLSLANG" true) # The following imported targets are referenced, but are missing: SPIRV-Tools-opt
    (lib.cmakeBool "DISABLE_SYSTEM_LODEPNG" true) # Not packaged in nixpkgs
    (lib.cmakeBool "DISABLE_SYSTEM_VMA" true)
    (lib.cmakeBool "DISABLE_SYSTEM_XBYAK" true)

    # We don't want to bother upstream with potentially outdated compat reports
    (lib.cmakeBool "CITRA_ENABLE_COMPATIBILITY_REPORTING" true)
    (lib.cmakeBool "ENABLE_COMPATIBILITY_LIST_DOWNLOAD" false) # We provide this deterministically

    (lib.cmakeBool "ENABLE_SDL2_FRONTEND" enableSdl2Frontend)
    (lib.cmakeBool "ENABLE_QT" enableQt)
    (lib.cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslation)
    (lib.cmakeBool "ENABLE_WEB_SERVICE" enableWebService)
    (lib.cmakeBool "ENABLE_CUBEB" enableCubeb)
    (lib.cmakeBool "USE_DISCORD_PRESENCE" useDiscordRichPresence)
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  postPatch = let
    branchCaptialized = (lib.toUpper (lib.substring 0 1 branch) + lib.substring 1 (-1) branch);
  in ''
    # Fix file not found when looking in var/empty instead of opt
    mkdir externals/dynarmic/src/dynarmic/ir/var
    ln -s ../opt externals/dynarmic/src/dynarmic/ir/var/empty

    # Prep compatibilitylist
    ln -s ${compat-list} ./dist/compatibility_list/compatibility_list.json

    # We already know the submodules are present
    substituteInPlace CMakeLists.txt \
      --replace "check_submodules_present()" ""

    # Add versions
    echo 'set(BUILD_FULLNAME "${branchCaptialized} ${version}")' >> CMakeModules/GenerateBuildInfo.cmake

    # Add gamemode
    substituteInPlace externals/gamemode/include/gamemode_client.h --replace "libgamemode.so.0" "${lib.getLib gamemode}/lib/libgamemode.so.0"
  '';

  postInstall = let
    libs = lib.makeLibraryPath [ vulkan-loader ];
  in lib.optionalString enableSdl2Frontend ''
    wrapProgram "$out/bin/citra" \
      --prefix LD_LIBRARY_PATH : ${libs}
  '' + lib.optionalString enableQt ''
    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${libs}
    )
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://citra-emu.org";
    description = "The ${branch} branch of an open-source emulator for the Nintendo 3DS";
    longDescription = ''
      A Nintendo 3DS Emulator written in C++
      Using the nightly branch is recommended for general usage.
      Using the canary branch is recommended if you would like to try out
      experimental features, with a cost of stability.
    '';
    mainProgram = if enableQt then "citra-qt" else "citra";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      abbradar
      ashley
      ivar
    ];
  };
}
