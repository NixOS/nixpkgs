{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  zig_0_17,
  removeReferencesTo,
  runCommand,
  testers,
  writableTmpDirAsHomeHook,
}:

let
  nightlyTag = "nightly-2026-11-09-9e85de7";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "roc";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "roc-lang";
    repo = "roc";
    rev = "9e85de7aba79eaeb8ca589ab6a1ea581274c8930";
    hash = "sha256-XK2CMrOkZ/03NC1X102RttEjFrtLT/1m9fZzy2eHuw8=";
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
    zig_0_17.hook
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

  # roc installs its release binary from the `build-release` step, not from zig's
  # conventional `install` step (which builds roc's test hosts and tools), and
  # the zig hook's installPhase always runs `install`. So rerun `build-release`,
  # cached from buildPhase, with the prefix set.
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
    # This also re-signs the binary, which editing it above invalidated.
    + ''
      remove-references-to -t ${zig_0_17} $out/bin/roc
    '';

  disallowedReferences = [ zig_0_17 ];

  passthru.tests =
    let
      # Runs `script` next to a hello world program for roc's bundled default
      # platform; the script stores what that program printed in $output.
      testScript =
        name: script:
        runCommand name
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              # roc caches compiled artifacts under $HOME.
              writableTmpDirAsHomeHook
            ];
          }
          ''
            cat > main.roc <<'ROC'
            main! = |_args| {
                echo!("Hello from Roc!")
                Ok({})
            }
            ROC

            ${script}
            if [ "$output" != "Hello from Roc!" ]; then
              echo "${name} printed: $output" >&2
              exit 1
            fi
            touch $out
          '';
    in
    {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "roc version";
        version = nightlyTag;
      };

      # Compile and run a program, which `roc version` alone does not cover: it
      # would still pass on a compiler whose embedded LLD cannot link.
      helloTest = testScript "roc-test-hello" ''
        output=$(roc main.roc)
      '';

      # Optimizing LLVM codegen at --opt=speed, linked into a standalone
      # executable that no longer needs the compiler.
      aotTest = testScript "roc-test-aot" ''
        roc build --opt=speed main.roc
        output=$(./main)
      '';
    };

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
