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
multiStdenv.mkDerivation (finalAttrs: {
  pname = "millennium";
  version = "2.34.0";

  src = inputs.millennium-src;

  passthru = {
    assets = millennium-assets;
    shims = millennium-shims;
    frontend = millennium-frontend;
    python = millennium-python;
  };

  patches = [
    ./patches/inject_assets_shims.diff
    ./patches/add_compile_definitions.diff
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
    pkgsi686Linux.openssl
    pkgsi686Linux.libxtst
    millennium-python
    cacert
  ];

  cmakeGenerator = "Ninja";
  cmakeBuildType = "Release";
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-m32"
    "-DCMAKE_C_FLAGS=-m32"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGITHUB_ACTION_BUILD=ON"
    "-DDISTRO_NIX=ON"
    "-DNIX_FRONTEND=${millennium-frontend}/share/frontend"
    "-DNIX_SHIMS=${millennium-shims}/share/millennium/shims"
    "-DNIX_ASSETS=${millennium-assets}/share/millennium/assets"
    "-DNIX_PYTHON=${millennium-python}"
    "-DNIX_PYTHON_LIB=${millennium-python}/lib/libpython${millennium-python.pythonVersion}.so"
    "-DCURL_CA_BUNDLE=${cacert}/etc/ssl/certs/ca-bundle.crt"
    "-DCURL_CA_PATH=${cacert}/etc/ssl/certs"
  ];

  postPatch = ''
    mkdir -p deps

    prepare_dep() {
      local name="$1"
      local src="$2"
      echo "[Nix Millennium Build Setup] Preparing dependency: $name"
      cp -r --no-preserve=mode "$src" "deps/$name"
      chmod -R u+w "deps/$name"
    }

    echo "[Nix Millennium Build Setup] Copying all inputs..."
    ${
      let
        deps = [
          "zlib"
          "luajit"
          "luajson"
          "minhook"
          "mini"
          "websocketpp"
          "fmt"
          "json"
          "libgit2"
          "minizip"
          "curl"
          "incbin"
          "asio"
          "abseil"
          "re2"
        ];
      in
      lib.concatStrings (map (dep: "prepare_dep ${dep} \"${inputs."${dep}-src"}\"\n") deps)
    }

    echo "[Nix Millennium Build Setup] Initializing Git..."
    export HOME=$(pwd)
    git config --global init.defaultBranch main
    git config --global user.email "nix-build@localhost"
    git config --global user.name "Nix Build"
    git init
    git add .
    git commit -m "Dummy commit for build" > /dev/null 2>&1

    git init deps/luajit
    git -C deps/luajit add .
    git -C deps/luajit commit -m "Dummy Commit for Nix Build" > /dev/null 2>&1
    chmod -R u+rwx deps/
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
