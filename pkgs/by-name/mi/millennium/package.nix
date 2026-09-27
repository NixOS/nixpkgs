{
  cmake,
  gcc_multi,
  ninja,
  pkg-config,
  git,
  cacert,
  pkgsi686Linux,

  lib,
  multiStdenv,
  callPackage,
  fetchFromGitHub,

  sourcesJson ? ./sources.json,
  inputs ? builtins.mapAttrs (name: info: fetchFromGitHub info) (lib.importJSON sourcesJson),

  millennium-python ? pkgsi686Linux.python311,
  millennium-shims ? callPackage ./shims.nix { inherit (inputs) millennium-src; },
  millennium-assets ? callPackage ./assets.nix { inherit (inputs) millennium-src; },
  millennium-frontend ? callPackage ./frontend.nix { inherit (inputs) millennium-src; },
}:
let
  curlStatic =
    (pkgsi686Linux.curl.override {
      gssSupport = false;
      brotliSupport = false;
      ldapSupport = false;
      gsaslSupport = false;
      scpSupport = false;
      idnSupport = false;

      openssl = pkgsi686Linux.openssl.override { static = true; };
      zlib = pkgsi686Linux.zlib.override { static = true; };
    }).overrideAttrs
      (old: {
        configureFlags = old.configureFlags ++ [
          "--disable-shared"
          "--enable-static"
        ];
        dontDisableStatic = true;
      });
in
multiStdenv.mkDerivation (finalAttrs: {
  pname = "millennium";
  version = "2.35.0";

  src = inputs.millennium-src;

  passthru = {
    assets = millennium-assets;
    shims = millennium-shims;
    frontend = millennium-frontend;
    python = millennium-python;
  };

  patches = [
    ./patches/devendor_bootstrap_deps.diff
    ./patches/devendor_CMakeLists.diff
    ./patches/devendor_CMakeListsx64.diff
    ./patches/store_path_env.diff
    ./patches/bootstrap.diff
  ];

  nativeBuildInputs = [
    cmake
    gcc_multi
    ninja
    pkg-config
    git
  ];

  buildInputs = [
    pkgsi686Linux.gtk3
    pkgsi686Linux.libpsl
    (pkgsi686Linux.openssl.override { static = true; })
    pkgsi686Linux.libxtst
    millennium-python
    cacert

    # pkgsi686Linux.curlWithGnuTls
    curlStatic
    pkgsi686Linux.zlib
    pkgsi686Linux.fmt
    pkgsi686Linux.nlohmann_json
    pkgsi686Linux.libgit2
    pkgsi686Linux.minizip-ng
    pkgsi686Linux.asio
    pkgsi686Linux.abseil-cpp
    pkgsi686Linux.re2
    pkgsi686Linux.websocketpp
  ];

  cmakeGenerator = "Ninja";
  cmakeBuildType = "Release";
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-m32"
    "-DCMAKE_C_FLAGS=-m32"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGITHUB_ACTION_BUILD=ON"
    "-DDISTRO_NIX=ON"

    "-DMILLENNIUM_RUNTIME_PATH=${placeholder "out"}/lib/libmillennium_x86.so"

    "-DNIX_FRONTEND=${millennium-frontend}/share/frontend"
    "-DNIX_SHIMS=${millennium-shims}/share/millennium/shims"
    "-DNIX_ASSETS=${millennium-assets}/share/millennium/assets"

    "-DNIX_PYTHON=${millennium-python}"
    "-DNIX_PYTHON_LIB=${millennium-python}/lib/libpython${millennium-python.pythonVersion}.so"
    "-DNIX_PYTHON_INCLUDE=${millennium-python}/include/python${millennium-python.pythonVersion}"
    "-DCURL_USE_STATIC_LIBS=TRUE"
    "-DCMAKE_FIND_LIBRARY_SUFFIXES=.a"
  ];

  postPatch = ''
    mkdir -p deps/
    cp -r ${inputs.minhook-src} deps/minhook
    cp -r ${inputs.mini-src} deps/mini
    cp -r ${inputs.incbin-src} deps/incbin
    cp -r ${inputs.luajit-src} deps/luajit
    cp -r ${inputs.luajson-src} deps/luajson

    chmod -R u+w deps/

    find deps/luajit -type f -exec sed -i 's/COMMAND git show.*/COMMAND echo 1710000000 > \$\{CMAKE_CURRENT_BINARY_DIR\}\/luajit_relver.txt/g' {} +
    sed -i 's/void fpconv_init(void)/void fpconv_init_DISABLED(void)/g' deps/luajson/fpconv.c
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/
    install -Dm755 src/libmillennium_x86.so                      $out/lib/libmillennium_x86.so
    install -Dm755 src/boot/linux/libmillennium_bootstrap_86x.so $out/lib/libmillennium_bootstrap_86x.so
    install -Dm755 src/hhx64/libmillennium_hhx64.so              $out/lib/libmillennium_hhx64.so

    ln -s          $out/lib/libmillennium_bootstrap_86x.so       $out/lib/libXtst.so.6

    runHook postInstall
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Modding framework to create, manage and use themes/plugins for Steam";

    longDescription = "An open-source low-code modding framework to create, manage and use themes/plugins for the desktop Steam Client without any low-level internal interaction or overhead";

    maintainers = [
      lib.maintainers.trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
})
