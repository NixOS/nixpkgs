{
  lib,
  clangStdenv,
  autoPatchelfHook,
  fetchgit,
  cmakeMinimal,
  ninja,
  icu,
  perl,
  ruby,
  python3,
  rsync,
  enableStatic ? clangStdenv.hostPlatform.isStatic,
}:

clangStdenv.mkDerivation {
  pname = "javascriptcore";
  version = "unstable-2026-02-19";

  src = fetchgit {
    url = "https://github.com/WebKit/WebKit";
    rev = "e2639ef69577f28d66dc711233148970ba221657";
    hash = "sha256-J54SZ2uKWaXPJp2A8RATGzg2FgqDlZ0zoM8mmaxXY+c=";
    deepClone = false;
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    cmakeMinimal
    ninja
    perl
    ruby
    python3
    rsync
    autoPatchelfHook
  ];

  buildInputs = [
    icu
  ];

  cmakeFlags = [
    "-GNinja"
    "-DPORT=JSCOnly"
    "-DENABLE_C_LOOP=OFF"
    "-DUSE_SYSTEM_MALLOC=ON"
    "-DENABLE_C_LOOP=OFF"
    "-DDEVELOPER_MODE=ON"
    "-DENABLE_API_TESTS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    (lib.cmakeBool "ENABLE_STATIC_JSC" enableStatic)
  ];

  # WebKit doesn't have a CMake install target
  installPhase = ''
    mkdir -p $out/{bin,lib,include}

    # 1. Copy all headers from Source/JavaScriptCore while preserving directory structure
    # This will create $out/include/Source/JavaScriptCore/...
    find ../Source/JavaScriptCore -name "*.h" -exec cp --parents {} $out/include/ \;

    # 2. Move them to the standard include path and clean up the extra nesting
    mv $out/include/../Source/JavaScriptCore $out/include/JavaScriptCore
    rm -rf $out/include/../Source

    # 3. Copy WTF and bmalloc (straightforward paths)
    cp -r ../Source/WTF/wtf $out/include/
    mkdir -p $out/include/bmalloc
    cp -r ../Source/bmalloc/bmalloc/*.h $out/include/bmalloc/

    # 4. Copy Generated/Derived headers (InternalPromise, etc. live here)
    # These are usually in the build directory, not the source directory
    cp -r JavaScriptCore/DerivedSources/*.h $out/include/JavaScriptCore/ 2>/dev/null || true

    # 5. Binaries and Libraries
    cp bin/jsc $out/bin/
    cp lib/libJavaScriptCore* $out/lib/
  '';

  meta = {
    description = "The built-in JavaScript engine for WebKit, which implements ECMAScript as in ECMA-262 specification.";
    homepage = "https://docs.webkit.org/Deep%20Dive/JSC/JavaScriptCore.html";
    license = [
      lib.licenses.lgpl2Plus
      lib.licenses.bsd2
    ];
    maintainers = [ lib.maintainers.theoparis ];
    platforms = lib.platforms.all;
    mainProgram = "jsc";
  };
}
