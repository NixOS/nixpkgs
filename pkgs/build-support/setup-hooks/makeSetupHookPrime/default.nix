{
  lib,
  replaceVarsWith,
  sourceGuard,
  stdenvNoCC,
  testers,
  writeTextFile,
}:
# Docs in doc/build-helpers/special/makeSetupHookPrime.section.md
# See https://nixos.org/manual/nixpkgs/unstable/#build-helpers-special-makeSetupHookPrime
lib.makeOverridable (
  {
    name,
    script,
    nativeBuildInputs ? [ ],
    buildInputs ? [ ],
    useSourceGuard ? true,
    replacements ? { },
    passthru ? { },
    meta ? { },
  }:
  # NOTE: To enforce isolation, interpolating the path in `script` causes Nix to copy the file to its own store path,
  # containing nothing else.
  assert lib.assertMsg (lib.isPath script) "makeSetupHook': script must be a path";
  let
    templatedScriptName = if replacements == { } then name else "templated-${name}";
    templatedScript =
      if replacements == { } then
        "${script}"
      else
        replaceVarsWith {
          # Boilerplate
          __structuredAttrs = true;
          strictDeps = true;

          name = templatedScriptName;
          src = "${script}";
          inherit replacements;
        };
  in
  stdenvNoCC.mkDerivation {
    # Boilerplate
    __structuredAttrs = true;
    allowSubstitutes = false;
    preferLocalBuild = true;
    strictDeps = true;

    inherit name meta;

    src = null;
    dontUnpack = true;

    # Perhaps due to the order in which Nix loads dependencies (current node, then dependencies), we need to add sourceGuard
    # as a dependency in with a slightly earlier dependency offset.
    # Adding sourceGuard to `propagatedBuildInputs` causes our `setupHook` to fail to run with a `sourceGuard: command not found`
    # error.
    # See https://github.com/NixOS/nixpkgs/pull/31414.
    depsHostHostPropagated = lib.optionals useSourceGuard [ sourceGuard ];

    # Since we're producing a setup hook which will be used in nativeBuildInputs, all of our dependency propagation is
    # understood to be shifted by one to the right -- that is, the script's nativeBuildInputs correspond to this
    # derivation's propagatedBuildInputs, and the script's buildInputs correspond to this derivation's
    # depsTargetTargetPropagated.
    propagatedBuildInputs = nativeBuildInputs;
    depsTargetTargetPropagated = buildInputs;

    setupHook =
      if useSourceGuard then
        writeTextFile {
          name = "sourceGuard-${templatedScriptName}";
          text = ''
            sourceGuard ${lib.escapeShellArg name} ${lib.escapeShellArg templatedScript}
          '';
          derivationArgs = {
            # Boilerplate
            __structuredAttrs = true;
            strictDeps = true;
          };
        }
      else
        templatedScript;

    passthru = passthru // {
      tests = passthru.tests or { } // {
        shellcheck = testers.shellcheck {
          name = templatedScriptName;
          src = templatedScript;
        };
        shfmt = testers.shfmt {
          name = templatedScriptName;
          src = templatedScript;
        };
      };
    };
  }
)
