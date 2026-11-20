{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  lastbookSrc,
  version,
  vulkanSupport ? true,
}:

# lastbook-llm: Lastbook's pipe-only local-AI runner (packaging/llm/lastbook_llm.cpp)
# linked against llama.cpp at the exact build upstream evaluated and ships
# (packaging/llm/build_llm_linux.sh). Speaks JSON lines on stdin/stdout, opens
# no socket. ggml's backends are loaded at runtime from beside the binary: every
# CPU variant of the architecture, plus Vulkan for GPUs.
#
# pkgs.llama-cpp cannot be reused: the runner compiles llama.cpp's internal
# common/fit.cpp, log.cpp and json.cpp, which must match the libraries exactly,
# and upstream pins the llama.cpp build its model evaluation ran on.
let
  llamaTag = "b12032";
  llamaCpp = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = llamaTag;
    hash = "sha256-6VYDqRNeFWoD3/xep94OWLL+BOn1UYt+B2hDoK5jf6U=";
  };
in
stdenv.mkDerivation {
  pname = "lastbook-llm";
  inherit version;

  src = llamaCpp;

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals vulkanSupport [ shaderc ];
  buildInputs = lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
    spirv-headers
  ];

  # Upstream's configuration: shared libraries, backends as loadable modules,
  # every CPU variant, OpenMP, Vulkan; no RPC backend, no curl/OpenSSL, none of
  # llama.cpp's own programs (its CLI and server can download).
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "GGML_BACKEND_DL" true)
    (lib.cmakeBool "GGML_CPU_ALL_VARIANTS" (
      stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64
    ))
    (lib.cmakeBool "GGML_NATIVE" false)
    (lib.cmakeBool "GGML_OPENMP" true)
    (lib.cmakeBool "GGML_VULKAN" vulkanSupport)
    (lib.cmakeBool "GGML_RPC" false)
    (lib.cmakeBool "GGML_CCACHE" false)
    (lib.cmakeBool "LLAMA_BUILD_COMMON" false)
    (lib.cmakeBool "LLAMA_BUILD_TOOLS" false)
    (lib.cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (lib.cmakeBool "LLAMA_BUILD_TESTS" false)
    (lib.cmakeBool "LLAMA_BUILD_SERVER" false)
    (lib.cmakeBool "LLAMA_CURL" false)
    (lib.cmakeBool "LLAMA_OPENSSL" false)
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" "$ORIGIN")
    (lib.cmakeBool "CMAKE_BUILD_WITH_INSTALL_RPATH" true)
  ];

  # Only the libraries (the default target also builds llama.cpp's own app).
  buildPhase = ''
    runHook preBuild

    cmake --build . --target help > targets.txt
    cpus=$(grep -oE '^ggml-cpu[a-z0-9_.-]*' targets.txt | sort -u | tr '\n' ' ' || true)
    echo "CPU variants: $cpus"
    cmake --build . -j $NIX_BUILD_CORES --target llama ${lib.optionalString vulkanSupport "ggml-vulkan"} $cpus

    $CXX -std=c++17 -O3 -DNDEBUG \
      -I../include -I../ggml/include -I../common -I../vendor -I../src \
      ${lastbookSrc}/packaging/llm/lastbook_llm.cpp ../common/fit.cpp ../common/log.cpp ../common/json.cpp \
      ${lastbookSrc}/packaging/llm/fit_unused_win.cpp \
      -Lbin -lllama -lggml -lggml-base -pthread \
      -Wl,-rpath,'$ORIGIN' -Wl,--enable-new-dtags -Wl,--as-needed -o lastbook-llm

    runHook postBuild
  '';

  # The program and the libraries it loads, side by side (the backends are found
  # next to the executable); one real file per SONAME, as upstream ships them.
  installPhase = ''
    runHook preInstall

    d=$out/libexec/lastbook-llm
    mkdir -p $d
    install -m755 lastbook-llm $d/
    for f in bin/libllama.so bin/libggml.so bin/libggml-base.so; do
      cp -L $f $d/$(objdump -p $f | sed -n 's/^ *SONAME *//p')
    done
    cp bin/libggml-cpu*.so $d/
    ${lib.optionalString vulkanSupport "cp bin/libggml-vulkan.so $d/"}
    install -Dm644 ../LICENSE $out/share/licenses/lastbook-llm/LICENSE-llama.cpp.txt

    runHook postInstall
  '';

  # libvulkan is dlopen'ed through the Vulkan backend's NEEDED entry; make sure
  # the loader stays on the RUNPATH after shrinking.
  postFixup = lib.optionalString vulkanSupport ''
    patchelf --add-rpath ${lib.getLib vulkan-loader}/lib $out/libexec/lastbook-llm/libggml-vulkan.so
  '';

  meta = {
    description = "Pipe-only JSON-lines local LLM runner for Lastbook, linked against llama.cpp ${llamaTag}";
    homepage = "https://github.com/Immortal-Protocols/lastbook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ harvest316 ];
    platforms = lib.platforms.linux;
  };
}
