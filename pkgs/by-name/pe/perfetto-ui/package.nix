{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  fetchzip,
  pnpm_8,
  nodejs_22,
  python3,
  gn,
  ninja,
  emscripten,
  makeWrapper,
  miniserve,
  nix-update-script,
}:

let
  # C++ dependencies that perfetto's `tools/install-build-deps` would drop into
  # buildtools/. Only the subset needed to compile the trace_processor WebAssembly
  # modules is vendored here (the host tracing daemons are not built for the UI).
  # Revisions come from tools/install-build-deps at the pinned perfetto tag.
  gitDeps = {
    "abseil-cpp" = fetchgit {
      url = "https://chromium.googlesource.com/external/github.com/abseil/abseil-cpp.git";
      rev = "76bb24329e8bf5f39704eb10d21b9a80befa7c81";
      hash = "sha256-eB7OqTO9Vwts9nYQ/Mdq0Ds4T1KgmmpYdzU09VPWOhk=";
    };
    protobuf = fetchgit {
      url = "https://chromium.googlesource.com/external/github.com/protocolbuffers/protobuf.git";
      rev = "74211c0dfc2777318ab53c2cd2c317a2ef9012de";
      hash = "sha256-E8q8XupOXoCFpXyGNHArfBmVm6ebfDgaJlJyvMqpveU=";
    };
    re2 = fetchgit {
      url = "https://chromium.googlesource.com/external/github.com/google/re2.git";
      rev = "927f5d53caf8111721e734cf24724686bb745f55";
      hash = "sha256-0J1HVk+eR7VN0ymucW9dNlT36j16XIfCzcs1EVyEIEU=";
    };
    zlib = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/third_party/zlib.git";
      rev = "6f9b4e61924021237d474569027cfb8ac7933ee6";
      hash = "sha256-uAQHAAA400hGEqsqHA6mt+SttSpY0km/GG26aUsCzqo=";
    };
    zstd = fetchgit {
      url = "https://android.googlesource.com/platform/external/zstd.git";
      rev = "77211fcc5e08c781734a386402ada93d0d18d093";
      hash = "sha256-3RMhCoK4TSQTxRNAUdf7z/NU5TWlU0B4ZkQzGUPmnec=";
    };
    sqlite_src = fetchgit {
      url = "https://chromium.googlesource.com/external/github.com/sqlite/sqlite.git";
      rev = "a4643b451a2941f5e6965ab095d3057bc7cb2222";
      hash = "sha256-LEM1vVIk0ova55kxvvB9xeuO3iXOcc6b5bWlW66wCx8=";
    };
    expat = fetchgit {
      url = "https://chromium.googlesource.com/external/github.com/libexpat/libexpat.git";
      rev = "fa75b96546c069d17b8f80d91e0f4ef0cde3790d";
      hash = "sha256-CpyDi8PR7yF+Mszc/LqMNeBAZavoDoAQ/dQYHBKLXeM=";
    };
    open_csd = fetchgit {
      url = "https://android.googlesource.com/platform/external/OpenCSD.git";
      rev = "0ce01e934f95efb6a216a6efa35af1245151c779";
      hash = "sha256-oUDZ7Nm2a/Ce2ibIbZJaBUdwZEAvf4fOWecTy2PvcM4=";
    };
  };

  # A subset of llvm-project sources (the symbol demangler used by
  # trace_processor); shipped by perfetto as a source tarball on GCS.
  llvm-project = fetchurl {
    url = "https://storage.googleapis.com/perfetto/llvm-project-617a15a9eac96088ae5e9134248d8236e34b91b1.tgz";
    hash = "sha256-fiVBRGon8qCahFINp7yTzXF0m6Dxcxjy1Skfv0W5eVY=";
  };

  # SQLite amalgamation, fonts and the legacy catapult trace viewer are shipped
  # by perfetto as prebuilt archives on GCS (checksum is embedded in the URL).
  sqlite = fetchzip {
    url = "https://storage.googleapis.com/perfetto/sqlite-amalgamation-3500300.zip";
    hash = "sha256-87NZ1x3rGLUBR5CNalG5sw0ZlOd4wSVzctlMPe7lapM=";
    stripRoot = false;
  };
  typefaces = fetchzip {
    url = "https://storage.googleapis.com/perfetto/typefaces-2325f6ee28898f3c04b76ea6e27e5e0109eec20c7338d58808cba84212ed075c.tar.gz";
    hash = "sha256-OUaNtd9/W3OCXTUyKkzFuoRXTgdU374wD/YzxYZjQUk=";
    stripRoot = false;
  };
  catapult = fetchzip {
    url = "https://storage.googleapis.com/perfetto/catapult_trace_viewer-b30108e05268ce6c65bb4126b65f6bfac165d17f5c1fd285046e7e6fd76c209f.tar.gz";
    hash = "sha256-JmNYzCf8IX1hmbINERsGe2dx6N5y5rk+kTwCkiRKUJU=";
    stripRoot = false;
  };
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "perfetto-ui";
  version = "57.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "perfetto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MZrgnK5Nk33m7vN9m+iCJaCLP48C1sWVNq9r3JRVajE=";
  };

  patches = [
    # Build the wasm host tools with the system clang (NixOS has no /usr/include)
    # and skip perfetto's buildtools freshness check (deps are provided by Nix).
    ./non-hermetic-clang.patch
  ];

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-o3BW39IdYlPejcT9yv9gAgZqsaqTPIlzZCH+VtbyxRI=";
  };
  pnpmRoot = "ui";

  # ui/build.mjs runs gn itself; skip the gn setup-hook's own configure step.
  dontUseGnConfigure = true;

  nativeBuildInputs = [
    pnpm_8.configHook
    nodejs_22
    python3
    gn
    ninja
    emscripten
    makeWrapper
  ];

  env = {
    # Test-only devDependencies whose postinstall scripts try to download
    # browsers; the UI bundle does not need them.
    PUPPETEER_SKIP_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };

  postPatch = ''
    # gn/ninja: perfetto's tools/{gn,ninja} exec buildtools/linux64/{gn,ninja}.
    mkdir -p buildtools/linux64
    ln -s ${lib.getExe gn} buildtools/linux64/gn
    ln -s ${lib.getExe ninja} buildtools/linux64/ninja

    # Vendored C++ sources (would otherwise be fetched by install-build-deps).
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: dep: "ln -s ${dep} buildtools/${name}") gitDeps
    )}
    mkdir -p buildtools/expat
    ln -s ${gitDeps.expat} buildtools/expat/src

    # llvm-project demangler sources (tarball has a llvm-project/ top dir).
    tar xzf ${llvm-project} -C buildtools

    # SQLite amalgamation must sit flat at buildtools/sqlite/sqlite3.c.
    mkdir -p buildtools/sqlite
    cp -r ${sqlite}/. buildtools/sqlite/
    chmod -R u+w buildtools/sqlite
    if [ ! -e buildtools/sqlite/sqlite3.c ]; then
      d=$(dirname "$(find buildtools/sqlite -name sqlite3.c | head -1)")
      mv "$d"/* buildtools/sqlite/
    fi

    mkdir -p buildtools/typefaces buildtools/catapult_trace_viewer
    cp -r ${typefaces}/. buildtools/typefaces/
    cp -r ${catapult}/. buildtools/catapult_trace_viewer/

    # emscripten: perfetto's gn wasm toolchain calls
    # buildtools/linux64/emsdk/emscripten/{emcc,em++,emar} --em-config <path>.
    # Point them at the nixpkgs emscripten, dropping the bundled em-config so the
    # wrappers self-configure.
    mkdir -p buildtools/linux64/emsdk/emscripten
    for t in emcc em++ emar; do
      {
        echo '#!${clangStdenv.shell}'
        # Perfetto points emcc at its bundled emsdk via --em-config (gn toolchain)
        # or the EM_CONFIG env var (direct calls); drop both so the nixpkgs
        # emscripten configures itself.
        echo 'unset EM_CONFIG'
        echo 'if [ "$1" = "--em-config" ]; then shift 2; fi'
        echo 'exec ${lib.getBin emscripten}/bin/'"$t"' "$@"'
      } > buildtools/linux64/emsdk/emscripten/$t
      chmod +x buildtools/linux64/emsdk/emscripten/$t
    done

    patchShebangs tools
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    # emscripten needs a writable, prepopulated cache.
    export EM_CACHE=$TMPDIR/emscripten-cache
    cp -r ${lib.getBin emscripten}/share/emscripten/cache $EM_CACHE
    chmod -R u+w $EM_CACHE
    # Reproduce the deployed version string without a .git dir.
    export PERFETTO_VERSION_HEADER_OVERRIDE_SCM_REVISION=da1d152cf

    node ui/build.mjs --no-depscheck

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/perfetto-ui
    cp -r ui/out/dist/* $out/share/perfetto-ui/

    # Service workers require a secure context; localhost qualifies. COOP/COEP
    # enable the SharedArrayBuffer fast path.
    makeWrapper ${lib.getExe miniserve} $out/bin/perfetto-ui \
      --add-flags "--interfaces 127.0.0.1 --index index.html" \
      --add-flags "--header 'Cross-Origin-Opener-Policy: same-origin'" \
      --add-flags "--header 'Cross-Origin-Embedder-Policy: require-corp'" \
      --add-flags "$out/share/perfetto-ui"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Web UI for the Perfetto tracing and profiling analysis tool";
    homepage = "https://perfetto.dev/";
    downloadPage = "https://github.com/google/perfetto";
    license = lib.licenses.asl20;
    mainProgram = "perfetto-ui";
    maintainers = with lib.maintainers; [ dev-null-undefined ];
    platforms = lib.platforms.linux;
  };
})
