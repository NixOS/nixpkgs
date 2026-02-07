{
  cmake,
  ninja,
  pkg-config,
  git,
  cacert,

  lib,
  stdenv,

  inputs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "millennium-64";
  version = "2.34.0";

  src = inputs.millennium-src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    git
  ];

  buildInputs = [
    cacert
  ];

  cmakeGenerator = "Ninja";
  cmakeBuildType = "Release";
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGITHUB_ACTION_BUILD=ON"
    "-DDISTRO_NIX=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
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

    echo "[Nix Millennium Build Setup] Copying flake inputs to local writable directories"
    prepare_dep abseil "${inputs.abseil-src}"
    prepare_dep re2 "${inputs.re2-src}"

    echo "[Nix Millennium Build Setup] Initializing Git Repos and adding Dummy Commits"
    echo "[Nix Millennium Build Setup] Dummy commits are used to determine versions, but flake inputs strip git history, causing issues"

    export HOME=$(pwd)

    git config --global init.defaultBranch main
    git config --global user.email "nix-build@localhost"
    git config --global user.name "Nix Build"

    git init
    git add .
    git commit -m "Dummy commit for build" > /dev/null 2>&1

    chmod -R u+rwx deps/

    echo "[Nix] Patching CMakeLists to IGNORE 32-bit source..."
    sed -i '/add_subdirectory.*src)/s/^/#/' CMakeLists.txt
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/
    install -Dm755 src/hhx64/libmillennium_hhx64.so $out/lib/libmillennium_hhx64.so

    runHook postInstall
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Main Millennium Library used to load and apply plugins and themes";

    maintainers = [
      lib.maintainers.trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
})
