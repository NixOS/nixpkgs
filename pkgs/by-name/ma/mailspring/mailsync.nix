{
  lib,
  stdenv,
  callPackage,

  src,
  version,

  autoPatchelfHook,
  cmake,
  pkg-config,

  c-ares,
  curl,
  cyrus_sasl,
  glib,
  html-tidy,
  icu,
  libctemplate,
  libiconv,
  libsysprof-capture,
  libuuid,
  libxml2,
  pcre2,
  sqlite,
  xz,
  zlib,
}:
let
  # libetpan and mailcore2 have both been modified from their upstream sources, so we must provide the vendored derivations
  # See: https://github.com/Foundry376/Mailspring/blob/master/mailsync/Vendor/README.md
  mailspring-libetpan = callPackage ./libetpan.nix { inherit src version; };
  mailspring-mailcore2 = callPackage ./mailcore2.nix { inherit src version mailspring-libetpan; };
in
stdenv.mkDerivation {
  pname = "mailspring-sync";
  inherit src version;

  sourceRoot = "${src.name}/mailsync";

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    c-ares
    curl
    cyrus_sasl
    glib
    html-tidy
    icu
    libctemplate
    libsysprof-capture
    libuuid
    libxml2
    mailspring-libetpan
    mailspring-mailcore2
    pcre2
    sqlite
    xz
    zlib
  ]
  ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  runtimeDependencies = [
    html-tidy
  ];

  env =
    let
      FLAGS = toString [
        "-Wno-error=deprecated-declarations"
        "-Wno-error=incompatible-pointer-types"
      ];
    in
    {
      CFLAGS = FLAGS;
      CXXFLAGS = FLAGS;
    };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'IF(''${CMAKE_SYSTEM_NAME} MATCHES "Linux")' 'if(TRUE)'

    # Replace hardcoded host paths and vendored dependencies
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/include/libxml2" "${lib.getDev libxml2}/include/libxml2" \
      --replace-fail "find_library(RESOLV_LIB NAMES libresolv.a libresolv)" "set(RESOLV_LIB \"resolv\")" \
      --replace-fail "target_link_libraries(mailsync libetpan.a)" "target_link_libraries(mailsync ${mailspring-libetpan}/lib/libetpan${stdenv.hostPlatform.extensions.sharedLibrary})" \
      --replace-fail "target_link_libraries(mailsync libMailCore.a)" "target_link_libraries(mailsync ${mailspring-mailcore2}/lib/libMailCore.a)"

    # Replace hardcoded references to archives with library references
    # Transforms 'NAMES libfoo.a libfoo' into 'NAMES foo'
    sed -i -E 's/NAMES lib([a-zA-Z0-9]+)\.a lib\1/NAMES \1/g' CMakeLists.txt
  ''
  + lib.optionalString stdenv.isDarwin ''
    # UUID_LIB is provided by system frameworks
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_library(UUID_LIB NAMES uuid)" "set(UUID_LIB \"\")"

    # Remove GCC related linker flags
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")' ""

    # Inject system frameworks and dependencies
    substituteInPlace CMakeLists.txt \
      --replace-fail 'target_link_libraries(mailsync pthread sasl2 ssl crypto curl dl)' \
      'target_link_libraries(mailsync pthread sasl2 ssl crypto curl dl tidy iconv "-framework Foundation" "-framework CoreFoundation" "-framework Security" "-framework CoreServices" "-framework SystemConfiguration")'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp mailsync $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Email synchronization engine for Mailspring";
    homepage = "https://github.com/Foundry376/Mailspring-Sync";
    license = lib.licenses.gpl3Plus;
    hasNoMaintainersButDependents = true;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
