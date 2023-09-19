{ mkShell
, bash
, coreutils
, lib
, writeScript
, writeScriptBin
, writeText
}:

# This function creates a wrapper script that runs a command in a shell context.
{ # The shell that will execute the wrapper script
  shell ? bash + "/bin/bash"
, # The result of calling mkShell
  drv
, # Which commands to run before the payload call
  prelude ? ""
, # Name for the script derivation
  name ? null
, ...
}:

let
  shellDrv =
    if lib.isDerivation drv then drv
      else if lib.isList drv then mkShell { buildInputs = drv; }
      else mkShell drv;

  drvName = if name != null then name else "${shellDrv.name}-wrapper";

  # This function closely mirrors what this Nix code does:
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1102
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/eval.cc#L1981-L2036
  stringValue = value:
    # We can't just use `toString` on all derivation attributes because that
    # would not put path literals in the closure. So we explicitly copy
    # those into the store here
    if builtins.typeOf value == "path" then "${value}"
    else if builtins.typeOf value == "list" then toString (map stringValue value)
    else toString value;

  # A binary that calls the command to build the derivation
  builder = writeScript "buildDerivation" ''
    exec ${lib.escapeShellArg (stringValue shellDrv.drvAttrs.builder)} ${lib.escapeShellArgs (map stringValue shellDrv.drvAttrs.args)}
  '';

  # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L992-L1004
  drvEnv = lib.mapAttrs' (name: value:
    let str = stringValue value;
    in if lib.elem name (shellDrv.drvAttrs.passAsFile or [])
    then lib.nameValuePair "${name}Path" (writeText "pass-as-text-${name}" str)
    else lib.nameValuePair name str
  ) shellDrv.drvAttrs //
    # A mapping from output name to the nix store path where they should end up
    # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1253
    lib.genAttrs shellDrv.outputs (output: builtins.unsafeDiscardStringContext shellDrv.${output}.outPath);

  staticPath = "${dirOf shell}:${lib.makeBinPath [ builder coreutils ]}";

  env = drvEnv // {
    # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L1027-L1030
    # PATH = "/path-not-set";
    # Allows calling bash and `buildDerivation` as the Cmd
    PATH = staticPath;
  };

  variablePrelude = lib.pipe env [
    (builtins.mapAttrs (k: v: "export ${k}=${lib.escapeShellArg v}"))
    (builtins.attrValues)
    (builtins.concatStringsSep "\n")
  ];

  entrypointScript = writeScriptBin drvName ''
    #!${shell}
    unset PATH
    dontAddDisableDepTrack=1

    ${variablePrelude}
    # Required or source setup fails
    NIX_BUILD_TOP=$(mktemp -d)

    # TODO: https://github.com/NixOS/nix/blob/2.8.0/src/nix-build/nix-build.cc#L506
    [ -e $stdenv/setup ] && source $stdenv/setup
    PATH=${staticPath}:"$PATH"
    SHELL=${lib.escapeShellArg shell}
    BASH=${lib.escapeShellArg shell}
    set +e
    [ -n "$PS1" -a -z "$NIX_SHELL_PRESERVE_PROMPT" ] && PS1='\n\[\033[1;32m\][nix-shell:\w]\$\[\033[0m\] '
    if [ "$(type -t runHook)" = function ]; then
      runHook shellHook
    fi
    unset NIX_ENFORCE_PURITY
    shopt -u nullglob
    shopt -s execfail
    ${prelude}

    if [[ "${"$"}{BASH_SOURCE[0]}" == "${"$"}{0}" ]]; then
      "$@"
    fi
  '';
in entrypointScript.overrideAttrs (old: {
  passthru = ((shellDrv.passthru or {}) // {
    inherit shellDrv;
  });
  meta = (old.meta // (shellDrv.meta or {}));
})
