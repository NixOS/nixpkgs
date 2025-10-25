{
  lib,
  clangStdenv,
  fetchFromGitHub,
  perl,
  python3,
  ruby,
  cmake,
  ninja,
  pkg-config,
  lld,
  icu,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "bun-webkit";
  version = "0-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "oven-sh";
    repo = "WebKit";
    rev = "569baf4d25cdf6fde03a07412c5907cad1136fac";
    hash = "sha256-7h2jg7u1nu5Bo9PykOYIufoyiRsuCzgf0/QSoYRPVMI=";
    leaveDotGit = true;
    postFetch = ''
      find $out -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    python3
    ruby
    lld
  ];

  buildInputs = [ icu ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "PORT" "JSCOnly")
    (lib.cmakeBool "ENABLE_STATIC_JSC" true)
    (lib.cmakeBool "ENABLE_BUN_SKIP_FAILING_ASSERTIONS" true)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "USE_THIN_ARCHIVES" false)
    (lib.cmakeBool "USE_BUN_JSC_ADDITIONS" true)
    (lib.cmakeBool "USE_BUN_EVENT_LOOP" true)
    (lib.cmakeBool "ENABLE_FTL_JIT" true)
    (lib.cmakeBool "CMAKE_EXPORT_COMPILE_COMMANDS" true)
    (lib.cmakeBool "ALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS" true)
    (lib.cmakeBool "ENABLE_REMOTE_INSPECTOR" true)
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-fuse-ld=lld")
    (lib.cmakeFeature "ENABLE_ASSERTS" "AUTO")
  ];

  ninjaFlags = [ "jsc" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include/JavaScriptCore $out/Source/JavaScriptCore
    cp -r lib/*.a $out/lib
    cp *.h $out/include
    cp -r bin $out/bin
    find JavaScriptCore/DerivedSources/ -name "*.h" -exec sh -c 'cp "$1" "$out/include/JavaScriptCore/$(basename "$1")"' sh {} \;
    find JavaScriptCore/DerivedSources/ -name "*.json" -exec sh -c 'cp "$1" "$out/$(basename "$1")"' sh {} \;
    find JavaScriptCore/Headers/JavaScriptCore/ -name "*.h" -exec cp {} $out/include/JavaScriptCore/ \;
    find JavaScriptCore/PrivateHeaders/JavaScriptCore/ -name "*.h" -exec cp {} $out/include/JavaScriptCore/ \;
    cp -r WTF/Headers/wtf/ $out/include
    cp -r bmalloc/Headers/bmalloc/ $out/include
    cp -r ../Source/JavaScriptCore/Scripts $out/Source/JavaScriptCore
    cp ../Source/JavaScriptCore/create_hash_table $out/Source/JavaScriptCore

    runHook postInstall
  '';
})
