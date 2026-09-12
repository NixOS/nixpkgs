{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,

  cpp-interop,
  cling,

  # Jupyter / xeus stack
  xeus,
  xeus-zmq,
  nlohmann_json,
  argparse,
  pugixml,

  # Runtime libs
  zeromq,
  openssl,
  libuuid,
  curl,
  makeWrapper,

  # tests
  doctest,

  # installCheck
  python3,
  jq,

  # "clang-repl" | "cling"
  backend ? "clang-repl",
}:

let
  stdenv = clangStdenv;

  useCling = backend == "cling";
  cppInterop = cpp-interop.override { inherit backend; };

  # xeus-cpp 0.10.0 needs newer xeus / xeus-zmq than nixpkgs ships by default.
  xeus_6 = xeus.overrideAttrs (old: {
    version = "6.0.5";
    src = fetchFromGitHub {
      owner = "jupyter-xeus";
      repo = "xeus";
      tag = "6.0.5";
      hash = "sha256-nbjq4dzrukVsZI6X3lWpr9oCZV5IUu/vkqSNKD7o3vo=";
    };
    doCheck = false;
  });

  xeus_zmq_4 = (xeus-zmq.override { xeus = xeus_6; }).overrideAttrs (old: {
    version = "4.0.0";
    src = fetchFromGitHub {
      owner = "jupyter-xeus";
      repo = "xeus-zmq";
      tag = "4.0.0";
      hash = "sha256-Ux8klPh33XWFu9eu+GTk5ZcqIcoP/GM4/J1uaz9xRHI=";
    };
  });

  # The interpreter behind CppInterOp must be told where the C/C++ standard
  # library and Clang builtin headers live: there is no system compiler to detect
  # at runtime in the Nix sandbox. We pass this set via CppInterOp's runtime
  # override env var. For the Cling backend cling.flags already carries it; for
  # clang-repl we reuse the hermetic resource dir and include flags CppInterOp
  # exposes.
  resourceDir = if useCling then "${cling.unwrapped}/lib/clang/20" else cppInterop.resourceDir;
  interpreterArgs = lib.concatStringsSep " " (
    if useCling then cling.flags else cppInterop.interpreterArgs
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus-cpp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "compiler-research";
    repo = "xeus-cpp";
    tag = finalAttrs.version;
    hash = "sha256-r6ojIcebWzpP85Djl36EMucnfQQgjGJUakSbMYW+czs=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cppInterop
    xeus_6
    xeus_zmq_4
    nlohmann_json
    argparse
    pugixml
    zeromq
    openssl
    libuuid
    curl
  ];

  # xeus-cpp probes the host `c++` for its include search path and prepends the
  # result, which shadows the hermetic paths we hand it (Xcode's libc++ and SDK
  # win on any machine with Xcode). Skip the probe when those paths are supplied.
  postPatch = ''
    substituteInPlace src/xinterpreter.cpp --replace-fail \
      "Cpp::DetectSystemCompilerIncludePaths(CxxSystemIncludes);" \
      "if (const char* e = std::getenv(\"CPPINTEROP_EXTRA_INTERPRETER_ARGS\"); !e || !*e)
    Cpp::DetectSystemCompilerIncludePaths(CxxSystemIncludes);"
  '';

  cmakeFlags = [
    (lib.cmakeBool "XEUS_CPP_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    "-DXEUS_CPP_RESOURCE_DIR=${resourceDir}"
  ];

  # Make the kernel hermetic: hand the interpreter the include/resource flags it
  # needs, since it cannot probe a system compiler in the sandbox.
  postInstall = ''
    wrapProgram $out/bin/xcpp \
      --set-default CPPINTEROP_EXTRA_INTERPRETER_ARGS "${interpreterArgs}"

    # xeus-cpp builds the kernelspec argv from CMAKE_INSTALL_PREFIX *and* the
    # (absolute, under Nix) CMAKE_INSTALL_BINDIR, producing a doubled store path
    # for xcpp. Point each kernel.json back at the wrapped binary.
    for k in $out/share/jupyter/kernels/*/kernel.json; do
      substituteInPlace "$k" --replace-fail "$out/$out/bin/xcpp" "$out/bin/xcpp"
    done
  '';

  # Run the upstream doctest suite. Like the wrapped kernel, the test binary
  # drives CppInterOp directly, so it needs the same hermetic interpreter args.
  doCheck = true;
  checkInputs = [ doctest ];
  checkPhase = ''
    runHook preCheck

    export CPPINTEROP_EXTRA_INTERPRETER_ARGS="${interpreterArgs}"
    # The test binary is linked with the install RPATH ($out/lib), which does not
    # exist yet at check time; point it at the freshly built libxeus-cpp instead.
    export LD_LIBRARY_PATH="$PWD''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    cmake --build . --target check-xeus-cpp

    runHook postCheck
  '';

  # Smoke test: drive the installed, wrapped kernel through Papermill and check
  # it actually compiles and runs C++.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$(mktemp -d)
    mkdir -p "$HOME/kernels/xcpp"
    cat > "$HOME/kernels/xcpp/kernel.json" <<EOF
    {"argv":["$out/bin/xcpp","-std=c++17","-f","{connection_file}"],"language":"cpp","display_name":"C++"}
    EOF
    export JUPYTER_PATH="$HOME"

    cat > "$HOME/test.ipynb" <<'NBEOF'
    {"cells":[
      {"cell_type":"code","id":"a","metadata":{},"execution_count":null,"outputs":[],"source":["#include <iostream>"]},
      {"cell_type":"code","id":"b","metadata":{},"execution_count":null,"outputs":[],"source":["std::cout << \"Hello world.\" << std::endl;"]}
    ],"metadata":{"kernelspec":{"name":"xcpp","display_name":"C++","language":"cpp"}},"nbformat":4,"nbformat_minor":5}
    NBEOF

    ${python3.pkgs.papermill}/bin/papermill "$HOME/test.ipynb" "$HOME/out.ipynb" --kernel xcpp
    ${jq}/bin/jq -e '[.. | .text? // empty | tostring] | add | contains("Hello world.")' "$HOME/out.ipynb"

    runHook postInstallCheck
  '';

  passthru = {
    inherit backend;
    flags = interpreterArgs;
  };

  meta = {
    description = "Jupyter kernel for C++ based on CppInterOp (${backend} backend)";
    mainProgram = "xcpp";
    homepage = "https://github.com/compiler-research/xeus-cpp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
  };
})
