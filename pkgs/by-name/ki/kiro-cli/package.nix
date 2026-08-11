{
  lib,
  stdenv,
  buildFHSEnv,
  symlinkJoin,
  testers,
  kiro-cli-unwrapped,
  # On Wayland, kiro-cli shells out to wl-clipboard (wl-copy/wl-paste) for
  # clipboard access. Enabling this puts wl-clipboard on the runtime PATH so
  # clipboard support works out of the box under Wayland sessions. Has no
  # effect on Darwin.
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

let
  inherit (kiro-cli-unwrapped) version meta;

  # Each of kiro-cli's user-facing commands, run inside a minimal FHS sandbox.
  # The sandbox provides a standard /lib64/ld-linux-x86-64.so.2 plus libgcc_s/
  # libstdc++ (via stdenv.cc.cc.lib), so the generic-glibc `bun` that
  # kiro-cli-chat extracts at runtime just works — no binary patching of the
  # extracted asset, and no build-time execution of the tool.
  fhsFor =
    executableName:
    buildFHSEnv {
      pname = executableName;
      inherit version;
      inherit executableName;
      runScript = executableName;

      targetPkgs =
        pkgs:
        [
          kiro-cli-unwrapped
          pkgs.stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1 for the extracted bun
        ]
        ++ lib.optional waylandSupport pkgs.wl-clipboard;

      meta = meta // {
        mainProgram = executableName;
      };
    };
in
# Darwin ships a normal .app bundle with no embedded-bun problem, so it needs
# no FHS sandbox; hand back the unwrapped derivation under the public name.
if stdenv.hostPlatform.isLinux then
  symlinkJoin {
    name = "kiro-cli-${version}";
    # Preserve the strictDeps = true that the unwrapped derivation exposes, so
    # the top-level attribute keeps it too (nixpkgs-vet NPV-165).
    strictDeps = true;
    paths = map fhsFor [
      "kiro-cli"
      "kiro-cli-chat"
      "kiro-cli-term"
    ];
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
    inherit meta;
  }
else
  kiro-cli-unwrapped.overrideAttrs { pname = "kiro-cli"; }
