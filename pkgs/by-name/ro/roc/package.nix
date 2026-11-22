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

  # Includes prebuilt LLVM, LLD and Binaryen from roc-lang/roc-bootstrap.
  # -Dsystem-llvm doesn't work: roc links LLVM statically against zig's libc++,
  # while nixpkgs' LLVM is built against libstdc++.
  deps = callPackage ./build.zig.zon.nix { };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    zig_0_17.hook
    removeReferencesTo
  ];

  zigBuildFlags = [
    "build-release"
    "-Dcompiler-version=${nightlyTag}"
    "-Dcoverage=false"
    "--system"
    "${finalAttrs.deps}"
  ];

  # Under nix, zig finds macOS frameworks only via -iframework in
  # NIX_CFLAGS_COMPILE, which the clang wrapper doesn't set. libobjc (re-exported
  # by CoreFoundation) lives in the SDK's usr/lib.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_CFLAGS_COMPILE+=" -iframework $SDKROOT/System/Library/Frameworks"
    export NIX_LDFLAGS+=" -L$SDKROOT/usr/lib"
  '';

  # roc installs from the `build-release` step, not `install`.
  dontUseZigInstall = true;
  installPhase = ''
    runHook preInstall

    local flagsArray=("-j$NIX_BUILD_CORES")
    concatTo flagsArray zigBuildFlags zigDefaultCpuFlag zigDefaultOptimizeFlag
    echoCmd 'zig install flags' "''${flagsArray[@]}"
    TERM=dumb zig build "''${flagsArray[@]}" --prefix "$out" --verbose

    runHook postInstall
  '';

  # roc looks for its macOS linker sysroot in a `darwin` dir next to the binary.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -R src/cli/darwin "$out/bin/darwin"
  '';

  postFixup =
    # zig adds every -L dir as an LC_RPATH; none are used at runtime and they
    # would pull ~1.5 GB of build-time paths into the closure.
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      for rpath in $(otool -l "$out/bin/roc" | awk '$1 == "path" { print $2 }'); do
        install_name_tool -delete_rpath "$rpath" "$out/bin/roc"
      done
    ''
    # Also re-signs the binary.
    + ''
      remove-references-to -t ${zig_0_17} $out/bin/roc
    '';

  disallowedReferences = [ zig_0_17 ];

  passthru.tests =
    let
      # `script` must set $output to what the program printed.
      testScript =
        name: script:
        runCommand name
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
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

      helloTest = testScript "roc-test-hello" ''
        output=$(roc main.roc)
      '';

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
    # LLVM, LLD and Binaryen are prebuilt.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
