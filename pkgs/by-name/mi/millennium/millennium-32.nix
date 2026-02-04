{
  cmake,
  ninja,
  pkg-config,
  git,
  cacert,
  pkgsi686Linux,

  lib,
  callPackage,
  fetchFromGitHub,

  sourcesJson ? ./sources.json,
  inputs ? builtins.mapAttrs (name: info: fetchFromGitHub info) (lib.importJSON sourcesJson),

  millennium-shims ? callPackage ./shims.nix { inherit (inputs) millennium-src; },
  millennium-frontend ? callPackage ./frontend.nix { inherit (inputs) millennium-src; },
  millennium-python ? callPackage ./python.nix { },
}:
pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "millennium-32";
  version = "2.34.0";

  src = inputs.millennium-src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    git
  ];

  buildInputs = [
    pkgsi686Linux.gtk3
    pkgsi686Linux.libpsl
    pkgsi686Linux.openssl
    pkgsi686Linux.libxtst
    cacert
    millennium-python
  ];

  cmakeGenerator = "Ninja";
  cmakeBuildType = "Release";
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGITHUB_ACTION_BUILD=ON"
    "-DDISTRO_NIX=ON"
    "-DNIX_FRONTEND=${millennium-frontend}/share/frontend"
    "-DNIX_SHIMS=${millennium-shims}/share/millennium/shims"
    "-DNIX_PYTHON=${millennium-python}"
    "-DCURL_CA_BUNDLE=${cacert}/etc/ssl/certs/ca-bundle.crt"
    "-DCURL_CA_PATH=${cacert}/etc/ssl/certs"
    "--preset=linux-release"
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

    echo "[Nix] Patching root CMakeLists to IGNORE 64-bit source..."
    sed -i '/add_subdirectory.*src\/hhx64)/s/^/#/' CMakeLists.txt

    echo "[Nix] Patching src/CMakeLists.txt to replace dynamic target reference..."
    sed -i 's|\$<TARGET_FILE:hhx64>|libmillennium_hhx64.so|g' src/CMakeLists.txt
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/
    install -Dm755 src/libmillennium_x86.so                      $out/lib/libmillennium_x86.so
    install -Dm755 src/boot/linux/libmillennium_bootstrap_86x.so $out/lib/libmillennium_bootstrap_86x.so

    runHook postInstall
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "32-bit Millennium Library for interfacing with the 32-bit Steam frontend";

    maintainers = with lib.maintainers; [
      trivaris
    ];

    platforms = [
      "i686-linux"
    ];
  };
})
