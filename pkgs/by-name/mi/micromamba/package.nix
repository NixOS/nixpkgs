{
  lib,
  stdenv,
  mamba-cpp,
  testers,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micromamba";
  version = mamba-cpp.version;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin

    # We copy the binary instead of symlinking.
    # Mamba determines its identity (mamba vs micromamba) by reading /proc/self/exe.
    # If we symlink, it resolves to 'mamba', causing shell init scripts to fail.
    # Ref: <https://github.com/NixOS/nixpkgs/pull/460788#issuecomment-3585230714>
    cp ${mamba-cpp}/bin/mamba $out/bin/micromamba
  '';

  passthru.tests = {
    # 1. Standard version check
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "micromamba --version";
    };

    # 2. Regression test for the shell initialization issue
    # This ensures that after sourcing the shell hook, `micromamba activate` works.
    # If the binary were a symlink resolving to 'mamba', the hook would define a
    # `mamba()` function instead of `micromamba()`, causing `micromamba activate` to fail.
    shell-init =
      runCommand "test-micromamba-shell-hook"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          # The shell hook includes 'complete' commands for bash completion,
          # which fail in non-interactive bash. We temporarily ignore errors
          # during eval since we only care about the function definition.
          set +e
          eval "$(micromamba shell hook --shell bash)" 2>/dev/null
          set -e

          # Test that the micromamba function works (not mamba).
          # If shell initialization fails above, then we expect to see an
          # error beginning with something like:
          #     'mamba' is running as a subprocess and can't modify the parent shell.
          micromamba activate

          touch $out
        '';
  };

  meta = mamba-cpp.meta // {
    maintainers = with lib.maintainers; [ mausch ];
    mainProgram = "micromamba";
  };
})
