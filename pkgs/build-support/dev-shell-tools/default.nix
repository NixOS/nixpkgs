{
  lib,
  runtimeShell,
  bashInteractive,
  stdenv,
  writeTextFile,
}:
let
  inherit (builtins) typeOf;
in
rec {
  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  # This function closely mirrors what this Nix code does:
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1102
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/eval.cc#L1981-L2036
  valueToString =
    value:
    # We can't just use `toString` on all derivation attributes because that
    # would not put path literals in the closure. So we explicitly copy
    # those into the store here
    if typeOf value == "path" then
      "${value}"
    else if typeOf value == "list" then
      toString (map valueToString value)
    else
      toString value;

  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L992-L1004
  unstructuredDerivationInputEnv =
    { drvAttrs }:
    # FIXME: this should be `normalAttrs // passAsFileAttrs`
    lib.mapAttrs'
      (
        name: value:
        let
          str = valueToString value;
        in
        if lib.elem name (drvAttrs.passAsFile or [ ]) then
          let
            nameHash =
              if builtins ? convertHash then
                builtins.convertHash {
                  hash = "sha256:" + builtins.hashString "sha256" name;
                  toHashFormat = "nix32";
                }
              else
                builtins.hashString "sha256" name;
            basename = ".attr-${nameHash}";
          in
          lib.nameValuePair "${name}Path" "${
            writeTextFile {
              name = "shell-passAsFile-${name}";
              text = str;
              destination = "/${basename}";
            }
          }/${basename}"
        else
          lib.nameValuePair name str
      )
      (
        removeAttrs drvAttrs [
          # TODO: there may be more of these
          "args"
        ]
      );

  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  derivationOutputEnv =
    { outputList, outputMap }:
    # A mapping from output name to the nix store path where they should end up
    # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1253
    lib.genAttrs outputList (output: builtins.unsafeDiscardStringContext outputMap.${output}.outPath);

  toBashEnv =
    { env }:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value:
        if lib.isValidPosixName name then ''export ${name}=${lib.escapeShellArg value}'' else ""
      ) env
    );

  buildShellEnv =
    {
      drvAttrs,
      promptPrefix ? "build shell",
      promptName ? null,
    }:
    let
      name = drvAttrs.pname or drvAttrs.name or "shell";
      env = unstructuredDerivationInputEnv { inherit drvAttrs; };
    in
    stdenv.mkDerivation (finalAttrs: {
      name = "${name}-env";
      passAsFile = [
        "bashEnv"
        "bashrc"
        "runShell"
      ];
      bashEnv = toBashEnv { inherit env; };
      bashrc = ''
        export NIXPKGS_SHELL_TMP="$(mktemp -d --tmpdir nixpkgs-shell-${name}.XXXXXX)"
        export TMPDIR="$NIXPKGS_SHELL_TMP"
        export TEMPDIR="$NIXPKGS_SHELL_TMP"
        export TMP="$NIXPKGS_SHELL_TMP"
        export TEMP="$NIXPKGS_SHELL_TMP"

        echo "Using TMPDIR=$TMPDIR"

        source @envbash@

        mkdir -p $TMP/outputs
        for _output in $outputs; do
          export "''${_output}=$TMP/outputs/''${_output}"
        done

        source @stdenv@/setup

        # Set a distinct prompt to make it clear that we are in a build shell
        case "$PS1" in
          *"(build shell $name)"*)
            echo "It looks like your running a build shell inside a build shell."
            echo "It might work, but this is probably not what you want."
            echo "You may want to exit your shell before loading a new one."
            ;;
        esac

        # Prefix a line to the prompt to indicate that we are in a build shell
        PS1=$"\n(\[\033[1;33m\]"${lib.escapeShellArg promptPrefix}$": \[\033[1;34m\]"${
          if promptName != null then lib.escapeShellArg promptName else ''"$name"''
        }"\[\033[1;33m\]\[\033[0m\]) $PS1"

        runHook shellHook
      '';
      buildCommand = ''
        mkdir -p $out/lib $out/bin
        bashrc="$out/lib/bashrc"
        envbash="$out/lib/env.bash"

        mv "$bashEnvPath" "$envbash"
        substitute "$bashrcPath" "$bashrc" \
          --replace-fail "@envbash@" "$envbash" \
          --replace-fail "@stdenv@" "$stdenv" \
          ;

        substitute ${./run-shell.sh} "$out/bin/run-shell" \
          --replace-fail "@bashrc@" "$bashrc" \
          --replace-fail "@runtimeShell@" "${runtimeShell}" \
          --replace-fail "@bashInteractive@" "${bashInteractive}" \
          ;

        # NOTE: most other files are script for the source command, and not
        #       standalone executables, so they should not be made executable.
        chmod a+x $out/bin/run-shell
      '';
      preferLocalBuild = true;
      passthru = {
        # Work this as a shell environment, so that commands like `nix-shell`
        # will be able to check it and use it correctly. This also lets Nix know
        # to stop when the user requests pkg.devShell explicitly, or a different
        # attribute containing a shell environment.
        isShellEnv = true;
        devShell = throw "You're trying to access the devShell attribute of a shell environment. We appreciate that this is very \"meta\" and interesting, but it's usually just not what you want. Most likely you've selected one `.devShell` to deep in an expression or on the command line. Try removing the last one.";
      };
      meta = {
        description = "An environment similar to the build environment of ${name}";
        # TODO longDescription
        mainProgram = "run-shell";
      };
    });
}
