{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  zig_0_16,
  writableTmpDirAsHomeHook,
  removeReferencesTo,
}:

let
  nightlyTag = "nightly-2026-09-18-1d982dc";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "roc";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "roc-lang";
    repo = "roc";
    rev = "1d982dca644aaddf1cc858f8580fadccf025358b";
    hash = "sha256-UrHnM2tIXVGdx9glGlP88a7pK/ENpdlLC6D6Wm7WxD4=";
  };

  # Zig source dependencies plus the prebuilt LLVM, LLD, Binaryen and zlib that
  # roc-lang/roc-bootstrap builds for each host platform.
  #
  # -Dsystem-llvm does not work in their place. roc links LLVM and LLD
  # statically against Zig's bundled libc++ (addStaticLlvmOptionsToModule in
  # build.zig sets link_libcpp), while nixpkgs' LLVM is built against libstdc++,
  # so the link fails on the libstdc++-only symbols its archives reference
  # (std::__throw_system_error(int) and friends). Binaryen is linked statically
  # from the same archive and is not packaged separately either.
  deps = callPackage ./build.zig.zon.nix { };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    zig_0_16.hook
    removeReferencesTo
  ];

  # -Dcoverage=false: Coverage is a CI-only step.
  zigBuildFlags = [
    "build-release"
    "-Dcompiler-version=${nightlyTag}"
    "-Dcoverage=false"
    "--system"
    "${finalAttrs.deps}"
  ];

  # On a macOS host zig learns where the SDK is from NIX_CFLAGS_COMPILE and
  # NIX_LDFLAGS alone (lib/std/zig/system/NativePaths.zig takes the nix branch and
  # returns before it would run xcrun), and it reads framework directories only
  # from `-iframework`, which nixpkgs' clang wrapper never sets because it reaches
  # the SDK through -isysroot. So name both halves the way that detection expects:
  # roc links CoreFoundation and CoreServices for its FSEvents file watcher, and
  # those frameworks in turn re-export /usr/lib/libobjc.A.dylib, which resolves to
  # libobjc.A.tbd in the SDK's own usr/lib. Without them the release link fails
  # with "unable to find framework" and "unable to resolve dependency".
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_CFLAGS_COMPILE+=" -iframework $SDKROOT/System/Library/Frameworks"
    export NIX_LDFLAGS+=" -L$SDKROOT/usr/lib"
  '';

  dontUseZigInstall = true;
  installPhase = ''
    runHook preInstall

    local flagsArray=("-j$NIX_BUILD_CORES")
    concatTo flagsArray zigBuildFlags zigDefaultCpuFlag zigDefaultOptimizeFlag
    echoCmd 'zig install flags' "''${flagsArray[@]}"
    TERM=dumb zig build "''${flagsArray[@]}" --prefix "$out" --verbose

    runHook postInstall
  '';

  # Every Mach-O link roc performs passes `-syslibroot` to its embedded LLD, and
  # roc resolves that sysroot as a `darwin` directory beside its own executable,
  # the layout roc's own macOS release tarballs ship. Without this copy roc falls
  # back to the sysroot path baked in at build time, which names the build
  # directory that is gone by the time anyone runs the compiler.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -R src/cli/darwin "$out/bin/darwin"
  '';

  postFixup =
    # zig records every -L directory it linked with as an LC_RPATH whenever the
    # target is native, so the binary ends up naming the SDK, the prebuilt LLVM
    # archive and the stdenv's own library directories. It loads nothing through
    # any of them - `otool -L` lists only system libraries - and keeping them
    # would hold ~1.5 GB of build-time-only paths in roc's runtime closure.
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      for rpath in $(otool -l "$out/bin/roc" | awk '$1 == "path" { print $2 }'); do
        install_name_tool -delete_rpath "$rpath" "$out/bin/roc"
      done
    ''
    # This also re-signs the binary, which editing it above invalidated; the
    # install check below runs it, so a signature left broken fails the build.
    + ''
      remove-references-to -t ${zig_0_16} $out/bin/roc
    '';

  # The invariant postFixup exists to keep: no zig path back in the closure.
  disallowedReferences = [ zig_0_16 ];

  doInstallCheck = true;

  # roc caches compiled artifacts under $HOME.
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    # The sysroot path baked in at build time points into this source tree, and
    # a build tree that still has it would hide a missing install. Move it away
    # so the Mach-O links below can only use the copy installed next to the
    # binary.
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''mv src/cli/darwin "$TMPDIR/build-tree-darwin"''}

    versionOutput=$("$out/bin/roc" version)
    if [ "$versionOutput" != "Roc compiler version ${nightlyTag}" ]; then
      echo "roc version printed: $versionOutput" >&2
      exit 1
    fi

    # Compile and run a program against roc's bundled default platform. `roc
    # version` alone would still pass on a compiler whose embedded LLD cannot
    # link, which is the failure mode a bad LLVM link produces.
    mkdir -p "$TMPDIR/helloTest"
    cat >"$TMPDIR/helloTest/main.roc" <<'ROC'
    main! = |_args| {
        echo!("Hello from Roc!")
        Ok({})
    }
    ROC

    helloTestOutput=$(cd "$TMPDIR/helloTest" && "$out/bin/roc" main.roc)
    if [ "$helloTestOutput" != "Hello from Roc!" ]; then
      echo "helloTest test printed: $helloTestOutput" >&2
      exit 1
    fi

    # `roc build` covers what running a program does not: optimizing LLVM
    # codegen at --opt=speed, linked by the embedded LLD into a standalone
    # binary that no longer needs the compiler. roc writes the executable to
    # the working directory, so build from a writable one.
    mkdir -p "$TMPDIR/aot"
    cp test/echo/hello.roc "$TMPDIR/aot/hello.roc"
    (cd "$TMPDIR/aot" && "$out/bin/roc" build --opt=speed hello.roc)
    aotOutput=$("$TMPDIR/aot/hello")
    if [ "$aotOutput" != "Hello, World!" ]; then
      echo "roc build produced a binary that printed: $aotOutput" >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Fast, friendly, functional programming language";
    homepage = "https://www.roc-lang.org/";
    license = lib.licenses.upl;
    mainProgram = "roc";
    maintainers = with lib.maintainers; [
      anton-4
      bhansconnect
      rtfeldman
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    # The LLVM, LLD and Binaryen roc links come prebuilt from
    # roc-lang/roc-bootstrap; everything else is built from source.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
