{
  lib,
  stdenv,
  faust,
  makeWrapper,
  llvm,
  ncurses,
  zlib,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faust-benchmark-tools";
  inherit (faust) version src;

  __structuredAttrs = true;
  strictDeps = true;

  # The benchmark tools live in their own directory with their own Makefile,
  # decoupled from the main CMake build.
  sourceRoot = "${finalAttrs.src.name}/tools/benchmark";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    # The benchmark binaries link ${faust}/lib/libfaust.a statically and
    # include headers from ${faust}/include. The runtime scripts find `faust`,
    # `faustpath`, and `faustoptflags` via the PATH wrap in postFixup.
    faust
    llvm
    ncurses
    zlib
    libxml2
  ];

  postPatch = ''
    # --build rather than --host: under strictDeps there is no host bash in
    # scope, so --host silently leaves the shebangs alone. This package is
    # native-only anyway (see meta).
    patchShebangs --build faustbench faust2object faust-tester
  '';

  makeFlags = [
    "FAUST=${faust}/bin/faust"
    # Upstream's Makefile hardcodes ../../build on Darwin (they can't run an
    # arm64 faust on their x86 CI runner) and only derives these from FAUST on
    # other platforms. We build natively, so point them at the real faust
    # output unconditionally.
    "LIB=${faust}/lib"
    "INC=${faust}/include"
    "FARCH=${faust}/share/faust"
    # The Makefile only shells out to `llvm-config` when LLVM is unset
    # (`ifndef LLVM`), so setting it here avoids needing llvm-config on PATH.
    "LLVM=$(shell ${lib.getDev llvm}/bin/llvm-config --link-static --ldflags --libs all --system-libs)"
    # Restrict to the non-audio, non-GUI tools. Avoids pulling in
    # gtk2/jack2/libsamplerate/liblo. The Makefile uses `TARGETS ?= …`.
    "TARGETS=dynamic-faust faustbench-llvm faustbench-llvm-interp faustbench-interp interp-tracer"
  ];

  enableParallelBuilding = true;

  # Upstream's `install` target doesn't create its target directories, and
  # unconditionally installs the wasm/iOS tools and faustbench.cpp regardless
  # of TARGETS, which would defeat the restriction above.
  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin \
      dynamic-faust \
      faustbench-llvm \
      faustbench-llvm-interp \
      faustbench-interp \
      interp-tracer \
      faustbench \
      faust2object \
      faust-tester

    # faustbench reads this file at runtime to assemble its C++ test harness.
    install -Dm644 faustbench.cpp $out/share/faust/faustbench.cpp

    runHook postInstall
  '';

  postFixup = ''
    # `faustbench` reads $FAUSTLIB/faustbench.cpp, but $FAUSTLIB is set by
    # faustpath to ${faust}/share/faust which does not contain our copy.
    # Redirect to the copy we just installed.
    substituteInPlace $out/bin/faustbench \
      --replace-fail '$FAUSTLIB/faustbench.cpp' "$out/share/faust/faustbench.cpp"

    # Plain PATH wrap is enough for faust-tester (just calls faust2plot from
    # faust). faustbench and faust2object compile C++ at runtime, so they need
    # the build environment exported too.
    wrapProgram $out/bin/faust-tester \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ faust ]}"

    # Mirror what faust.wrapWithBuildEnv does for the two compile-driving
    # scripts, so users get a working $CXX and friends without a dev shell.
    # (wrapWithBuildEnv itself is a whole-derivation builder — dontBuild, its
    # own installPhase copying from tools/faust2appls — so it can't wrap
    # binaries we compile here.)
    nix_cc_wrapper_target_host="$(printenv | grep ^NIX_CC_WRAPPER_TARGET_HOST | sed 's/=.*//')"
    nix_bintools_wrapper_target_host="$(printenv | grep ^NIX_BINTOOLS_WRAPPER_TARGET_HOST | sed 's/=.*//')"
    for s in faustbench faust2object; do
      wrapProgram $out/bin/$s \
        --prefix PATH : "$out/bin:${lib.makeBinPath [ faust ]}:$PATH" \
        --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH" \
        --set NIX_CFLAGS_COMPILE "$NIX_CFLAGS_COMPILE" \
        --set NIX_LDFLAGS "$NIX_LDFLAGS -lpthread" \
        --set "$nix_cc_wrapper_target_host" "''${!nix_cc_wrapper_target_host}" \
        --set "$nix_bintools_wrapper_target_host" "''${!nix_bintools_wrapper_target_host}"
    done
  '';

  # Version is inherited from `faust`; bumping faust auto-bumps this. No
  # passthru.updateScript needed.

  meta = {
    description = "Benchmarking, tracing, and dynamic-compilation tools for the Faust compiler";
    longDescription = ''
      A subset of the tools from the upstream Faust `tools/benchmark/`
      directory: dynamic-faust, faustbench-llvm, faustbench-llvm-interp,
      faustbench-interp, interp-tracer (binaries built against libfaust.a),
      plus the scripts faustbench, faust2object, and faust-tester.

      This package intentionally excludes the JACK/GTK runners (dynamic-jack-gtk,
      faust-osc-controller, signal-tester, box-tester) and the WASM bench
      tools to keep the closure small. They can be packaged separately if
      needed.
    '';
    homepage = "https://github.com/grame-cncm/faust/tree/master-dev/tools/benchmark";
    changelog = "https://github.com/grame-cncm/faust/blob/${finalAttrs.version}/Changes.txt";
    license = lib.licenses.gpl3Plus;
    # Cross is not wired up: llvm-config is executed at build time from
    # buildInputs, and faust2object invokes it again at runtime on the host.
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "faustbench";
  };
})
