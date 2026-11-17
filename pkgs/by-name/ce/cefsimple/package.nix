{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  makeWrapper,
  cef-binary,
  libx11,
}:

stdenv.mkDerivation {
  pname = "cefsimple";
  inherit (cef-binary) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "chromiumembedded";
    repo = "cef";
    rev = cef-binary.gitRevision;
    hash = "sha256-mumgd/BMShBjV4Am9tzteveMotlTwdznUcTaGrrIDEQ=";
  };

  postUnpack = ''
    mkdir cef
    cp -r --no-preserve=mode ${cef-binary}/{cmake,include,libcef_dll,CMakeLists.txt} cef/
    ln -s ${cef-binary}/{Release,Resources} cef/
    mkdir cef/tests
    cp -r --no-preserve=mode $sourceRoot/tests/cefsimple cef/tests/
    sourceRoot=cef
  '';

  postPatch = ''
    sed -i '/add_subdirectory(tests\/\(cefsimple_capi\|gmock\|gtest\|ceftests\))/d' CMakeLists.txt

    cat > tests/cefsimple/CMakeLists.txt <<'EOF'
    set(CEFSIMPLE_SRCS simple_app.cc simple_app.h simple_handler.cc simple_handler.h)
    set(CEFSIMPLE_SRCS_LINUX cefsimple_linux.cc simple_handler_linux.cc)
    set(CEFSIMPLE_SRCS_MAC cefsimple_mac.mm simple_handler_mac.mm)
    APPEND_PLATFORM_SOURCES(CEFSIMPLE_SRCS)
    set(CEFSIMPLE_HELPER_SRCS_MAC process_helper_mac.cc)
    APPEND_PLATFORM_SOURCES(CEFSIMPLE_HELPER_SRCS)
    set(CEFSIMPLE_RESOURCES_SRCS_MAC mac/Info.plist.in mac/cefsimple.icns mac/English.lproj/InfoPlist.strings)
    APPEND_PLATFORM_SOURCES(CEFSIMPLE_RESOURCES_SRCS)
    EOF
    sed '/^{{/,/^}}/d' tests/cefsimple/CMakeLists.txt.in >> tests/cefsimple/CMakeLists.txt
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Accessory app so headless launches take no Dock tile and don't steal
    # focus; Accessory (not LSBackgroundOnly) still permits the window CEF needs.
    substituteInPlace tests/cefsimple/mac/Info.plist.in \
      --replace-fail '<key>NSPrincipalClass</key>' \
                     '<key>LSUIElement</key><true/><key>NSPrincipalClass</key>'
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  cmakeFlags = [
    (lib.cmakeFeature "PROJECT_ARCH" (if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64"))
  ];

  ninjaFlags = [ "cefsimple" ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r tests/cefsimple/Release/cefsimple.app $out/Applications/
        framework="$out/Applications/cefsimple.app/Contents/Frameworks/Chromium Embedded Framework.framework"
        rm -r "$framework"
        ln -s "${cef-binary}/Release/Chromium Embedded Framework.framework" "$framework"
        makeWrapper $out/Applications/cefsimple.app/Contents/MacOS/cefsimple $out/bin/cefsimple

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm755 tests/cefsimple/Release/cefsimple -t $out/libexec/cefsimple
        ln -s ${cef-binary}/Release/* ${cef-binary}/Resources/* $out/libexec/cefsimple/
        mkdir -p $out/bin
        ln -s $out/libexec/cefsimple/cefsimple $out/bin/cefsimple

        runHook postInstall
      '';

  # libcef.so must be loaded from next to the executable, where its resources are
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath '$ORIGIN:${
      lib.makeLibraryPath [
        libx11
        stdenv.cc.cc
      ]
    }' $out/libexec/cefsimple/cefsimple
  '';

  meta = {
    description = "Minimal browser built on the Chromium Embedded Framework";
    homepage = "https://github.com/chromiumembedded/cef/tree/master/tests/cefsimple";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "cefsimple";
    inherit (cef-binary.meta) platforms;
  };
}
