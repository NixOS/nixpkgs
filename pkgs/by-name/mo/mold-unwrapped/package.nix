{
  buildPackages,
  clangStdenv,
  fetchFromGitHub,
  gccStdenv,
  hello,
  lib,
  mold,
  nix-update-script,
  runCommandCC,
  rustPlatform,
  stdenv,
  useMoldLinker,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mold-unwrapped";
  version = "3.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rui314";
    repo = "mold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XigEJb7wv46XuzT9s83pllLxCqN0Va3ZN7P/Ch9qXsY=";
  };

  cargoHash = "sha256-DgCFmTz+qulwXu1Oax8gBnc/6HIT6TlY8+xzBRGFvu0=";

  preCheck = ''
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    patchShebangs tests
  ''
  + lib.concatMapStringsSep "\n" (x: "rm tests/${x}.sh") [
    "comdat-odr"
    "icf-gcc-except-table"
    "icf-preemption"
    "linker-script-group-as-needed"
    "lto-archive"
    "mold-wrapper"
    "rpath"
    "run"
    "tls-df-static-tls"
    "tls-le-error"
  ];

  postInstall = ''
    cp $out/bin/{mold,ld.mold}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests =
      let
        helloTest =
          name: helloMold:
          let
            command = "$READELF -p .comment ${lib.getExe helloMold}";
            emulator = stdenv.hostPlatform.emulator buildPackages;
          in
          runCommandCC "mold-${name}-test" { passthru = { inherit helloMold; }; } ''
            echo "Testing running the 'hello' binary which should be linked with 'mold'" >&2
            ${emulator} ${lib.getExe helloMold}

            echo "Checking for mold in the '.comment' section" >&2
            if output=$(${command} 2>&1); then
              if grep -Fw -- "mold" - <<< "$output"; then
                touch $out
              else
                echo "No mention of 'mold' detected in the '.comment' section" >&2
                echo "The command was:" >&2
                echo "${command}" >&2
                echo "The output was:" >&2
                echo "$output" >&2
                exit 1
              fi
            else
              echo -n "${command}" >&2
              echo " returned a non-zero exit code." >&2
              echo "$output" >&2
              exit 1
            fi
          '';
      in
      lib.optionalAttrs stdenv.hostPlatform.isLinux {
        adapter-gcc = helloTest "adapter-gcc" (
          hello.override (old: {
            stdenv = useMoldLinker gccStdenv;
          })
        );
        adapter-llvm = helloTest "adapter-llvm" (
          hello.override (old: {
            stdenv = useMoldLinker clangStdenv;
          })
        );
        wrapped = helloTest "wrapped" (
          hello.overrideAttrs (previousAttrs: {
            nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [ mold ];
            env.NIX_CFLAGS_LINK = toString (previousAttrs.NIX_CFLAGS_LINK or "") + " -fuse-ld=mold";
          })
        );
      };
  };

  meta = {
    description = "A high-performance ELF linker, rewritten in Rust";
    longDescription = ''
      mold is a high-performance drop-in replacement for existing Unix linkers,
      designed to speed up builds.
    '';
    homepage = "https://github.com/rui314/mold";
    changelog = "https://github.com/rui314/mold/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "mold";
    maintainers = with lib.maintainers; [ azahi ];
  };
})
