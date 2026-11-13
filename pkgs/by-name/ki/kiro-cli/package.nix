{
  lib,
  stdenv,
  buildFHSEnv,
  makeWrapper,
  testers,
  writeShellScript,
  kiro-cli-unwrapped,
  # On Wayland, kiro-cli shells out to wl-clipboard (wl-copy/wl-paste) for
  # clipboard access. Enabling this puts wl-clipboard on the runtime PATH so
  # clipboard support works out of the box under Wayland sessions. Has no
  # effect on Darwin.
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

let
  inherit (kiro-cli-unwrapped) version meta;

  # All of kiro-cli's user-facing commands run inside one minimal FHS sandbox.
  # The sandbox provides a standard /lib64/ld-linux-x86-64.so.2 plus libgcc_s/
  # libstdc++ (via stdenv.cc.cc.lib), so the generic-glibc `bun` that
  # kiro-cli-chat extracts at runtime just works — no binary patching of the
  # extracted asset, and no build-time execution of the tool.
  #
  # buildFHSEnv provides a single entry point per environment, so instead of
  # building one environment per command (which would give kiro-cli, kiro-cli-chat
  # and kiro-cli-term separate derivations, each with its own unfree license and
  # each requiring its own entry in the unfree allowlist), we build a single
  # environment whose entry point dispatches to whichever command is passed to
  # it, and expose one thin wrapper per command via `extraInstallCommands`.
  # This keeps the unfree allowlist to two entries (`kiro-cli` and
  # `kiro-cli-unwrapped`) instead of four. The three binaries ship in the same
  # upstream artifact and share the same runtime needs, so there is no
  # per-command sandbox to lose.
  fhsenv = buildFHSEnv {
    pname = "kiro-cli";
    inherit version;

    runScript = writeShellScript "kiro-cli" ''
      command="$1"
      shift
      exec "$command" "$@"
    '';

    targetPkgs =
      pkgs:
      [
        kiro-cli-unwrapped
        pkgs.stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1 for the extracted bun
      ]
      ++ lib.optional waylandSupport pkgs.wl-clipboard;

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      mkdir -p $out/libexec/kiro-cli
      mv $out/bin/kiro-cli $out/libexec/kiro-cli/kiro-cli-wrapper

      for command in kiro-cli kiro-cli-chat kiro-cli-term; do
        makeWrapper "$out/libexec/kiro-cli/kiro-cli-wrapper" "$out/bin/$command" \
          --add-flags "$command"
      done
    '';

    passthru = {
      unwrapped = kiro-cli-unwrapped;
      tests.version = testers.testVersion {
        # The FHS wrapper needs user namespaces (bubblewrap), which aren't
        # available in the Nix build sandbox, so exercise the unwrapped binary
        # the wrapper ultimately execs.
        package = kiro-cli-unwrapped;
        inherit version;
      };
    };

    meta = meta // {
      mainProgram = "kiro-cli";
    };
  };
in
# Darwin ships a normal .app bundle with no embedded-bun problem, so it needs
# no FHS sandbox; hand back the unwrapped derivation under the public name.
if stdenv.hostPlatform.isLinux then
  fhsenv
else
  kiro-cli-unwrapped.overrideAttrs { pname = "kiro-cli"; }
