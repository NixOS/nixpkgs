{
  lib,
  clangStdenv,
  autoPatchelfHook,
  fetchurl,
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
  version = "unstable-2025-01-12";

  src = fetchurl {
    url = "https://github.com/WebKit/WebKit/archive/1615acbb126895eb148ca2b625639a9c7c282399.tar.gz";
    hash = "sha256-QLYBc/kjq5MARpK4YJSlGHDCr8FGo7OiKzqb92MaCrM=";
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
    "-DPORT=JSCOnly"
    "-GNinja"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    (lib.cmakeBool "ENABLE_STATIC_JSC" enableStatic)
  ];

  # WebKit doesn't have a CMake install target
  installPhase = ''
    mkdir -p $out/{bin,lib}
    mkdir -p $out/include/{JavaScriptCore,wtf,bmalloc}
    rsync -rav ../Source/JavaScriptCore/**/*.h $out/include/JavaScriptCore/
    rsync -rav --exclude '*.cpp' ../Source/WTF/wtf/* $out/include/wtf/
    rsync -rav ../Source/bmalloc/bmalloc/*.h $out/include/bmalloc
    rsync -rav JavaScriptCore/DerivedSources/*.h $out/include/JavaScriptCore/
    rsync -rav ../Source/bmalloc/libpas/src/libpas/*.h $out/include/bmalloc/
    rsync -rav bin/jsc $out/bin/
    rsync -rav lib/* $out/lib/
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
