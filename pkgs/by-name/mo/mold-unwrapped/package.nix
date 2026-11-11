{
  buildPackages,
  clangStdenv,
  fetchFromGitHub,
  gccStdenv,
  hello,
  installShellFiles,
  lib,
  mold,
  mold-unwrapped,
  nix-update-script,
  runCommand,
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

  strictDeps = true;
  nativeBuildInputs = [
    installShellFiles
  ];

  # Upstream integration tests are way to finicky to keep around. Our internal
  # linking tests should suffice.
  doCheck = false;

  postInstall = ''
    ln -s $out/bin/{,ld.}mold

    mkdir -p $out/lib/mold
    mv $out/lib/mold-wrapper.so $out/lib/mold

    installManPage docs/mold.1
    ln -s $out/share/man/man1/{,ld.}mold.1.gz
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests =
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in
      {
        run = runCommand "mold-run-test" { } ''
          ${emulator} ${lib.getExe mold-unwrapped} -run true
          if [[ "$?" == 0 ]]; then
            touch $out
          fi
        '';
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux (
        let
          helloTest =
            name: helloMold:
            let
              command = "$READELF -p .comment ${lib.getExe helloMold}";
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
        {
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
        }
      );
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
