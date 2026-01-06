{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  swiftPackages,
  apple-sdk_26,
  ibtool,
  libtapi,
  darwin,
  sqlite,
  libedit,
  openssl,
  zlib,
  python3,
  re-intentbuilderc,
  re-appintentsmetadataprocessor,
  re-plistbuddy,
  actool,
  rsync,
  libxml2,
  dumppif,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hammerspoon";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Hammerspoon";
    repo = "hammerspoon";
    rev = finalAttrs.version;
    hash = "sha256-2CQcYA7TP1gOd9DZiQbP2lbsMZwj5GEBn0zNwWx51pM=";
  };

  nativeBuildInputs = [
    apple-sdk_26
    actool
    dumppif
    swiftPackages.swift-build
    swiftPackages.swift
    ibtool
    openssl
    libtapi.bin
    re-intentbuilderc
    re-appintentsmetadataprocessor
    re-plistbuddy
    rsync
    xxd
  ];

  buildInputs = [ sqlite libedit.dev zlib libxml2 darwin.ICU ];
  dontStrip = true;
  dontPatchShebangs = true;

  patches = [
    ./0001-More-portable-mkCertTemplate.patch
  ];

  # 1. We can't use something like
  #   "CLANG_EXPLICIT_MODULES_LIBCLANG_PATH": "${llvmPackages.libclang.lib}/lib/libclang.dylib"
  # because the Apple's clang has some extra functionality that can be detected/confirmed at build time.
  # 2. We disable warning as errors, because there's bound to be warnings.
  # 3. swbuild uses `$(LD) -Xlinker ...` which doesn't work with `ld`. We need to use the compiler as the linker.
  postPatch = ''
    cat > settings.json <<EOF
{
  "overrides": {
    "environmentConfig": {
      "table": {
        "CODESIGN": "${darwin.sigtool2}/bin/codesign",
        "CODE_SIGN_IDENTITY": "-",
        "CODE_SIGN_INJECT_BASE_ENTITLEMENTS": "NO",
        "LD": "clang",
        "CLANG_ENABLE_EXPLICIT_MODULES": "NO",
        "GCC_TREAT_WARNINGS_AS_ERRORS": "NO",
        "SWIFT_STDLIB_TOOL_STRIP_BITCODE": "NO",
        "ARCHS": "arm64",
        "ONLY_ACTIVE_ARCH": "YES"
      }
    }
  }
}
EOF
    substituteInPlace extensions/hash/algorithms.m \
      --replace-fail "@import zlib ;" "#include <zlib.h>"
    substituteInPlace extensions/hash/libhash.m \
      --replace-fail "@import zlib ;" "#include <zlib.h>"
    substituteInPlace Hammerspoon.xcodeproj/project.pbxproj \
      --replace-fail "/bin/mkdir" "mkdir"
    substituteInPlace scripts/docs/bin/build_docs.py \
      --replace-fail '/usr/bin/env -S -P/usr/bin:''${PATH} python3' "${lib.getExe python3}"
    substituteInPlace Pods/Pods.xcodeproj/project.pbxproj \
      --replace-fail 'ditto' "cp -L"

    substituteInPlace "Pods/Target Support Files/CocoaHTTPServer/CocoaHTTPServer.release.xcconfig" \
      --replace-fail '$(SDKROOT)/usr/include/libxml2' "${lib.getDev libxml2}/include/libxml2"
    substituteInPlace "Pods/Target Support Files/Pods-Hammerspoon/Pods-Hammerspoon.release.xcconfig" \
      --replace-fail 'LIBRARY_SEARCH_PATHS = $(inherited)' 'LIBRARY_SEARCH_PATHS = $(inherited) ${lib.getLib darwin.ICU}/lib'
    substituteInPlace "Pods/Target Support Files/Pods-Hammerspoon/Pods-Hammerspoon-frameworks.sh" \
      --replace-fail '/usr/bin/codesign' '${darwin.sigtool2}/bin/codesign'
    substituteInPlace "Pods/Target Support Files/Pods-Hammerspoon/Pods-Hammerspoon-frameworks.sh" \
      --replace-fail "rev | cut -d ':' -f1 | awk '{\$1=\$1;print}' | rev" "awk -F': *' '{print \$NF}'"
    substituteInPlace "scripts/update_version_build_numbers.sh" \
      --replace-fail 'git=' 'git="" #'
    substituteInPlace "scripts/update_version_build_numbers.sh" \
      --replace-fail 'versionNumber=' 'versionNumber="${finalAttrs.version}" #'
    substituteInPlace "scripts/update_version_build_numbers.sh" \
      --replace-fail 'buildNumber=' 'buildNumber="0" #'
    substituteInPlace "scripts/update_version_build_numbers.sh" \
      --replace-fail '/usr/libexec/PlistBuddy' '${lib.getExe' re-plistbuddy "PlistBuddy"}'
  '';

  buildPhase = ''
    runHook preBuild
    #set -x
    ls -la
    export DEVELOPER_DIR=${apple-sdk_26}
    # module dependency discovery doesn't work, so we have to list them
    for component in Pods-Hammerspoon CocoaHTTPServer ASCIImage CocoaAsyncSocket PocketSocket MIKMIDI Sparkle SocketRocket ORSSerialPort lua LuaSkin Sentry Hammerspoon ; do
      if ! swbuild build Hammerspoon.xcworkspace --target $component --configuration Release --derivedDataPath $PWD/build --buildParametersFile $PWD/settings.json ; then
        echo "=== dev out ==="
        #find build/Products/Release/Hammerspoon.app
        exit 1
      fi
    done
    ${darwin.sigtool2}/bin/codesign \
      --force --sign - \
      -o runtime \
      --entitlements Hammerspoon/Hammerspoon.entitlements \
      --generate-entitlement-der \
      --timestamp=none \
      build/Products/Release/Hammerspoon.app

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r build/Products/Release/Hammerspoon.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      viraptor
    ];
    platforms = lib.platforms.darwin;
  };
})
