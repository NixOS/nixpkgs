{
  lib,
  stdenv,
  callPackage,
  pkgsCross,
  linkFarmFromDrvs,
  testers,
  generateShellCompletions,
}:

let
  # Host platform whose programs the build platform cannot execute
  pkgsHost =
    if stdenv.buildPlatform.isRiscV64 then pkgsCross.aarch64-multiplatform else pkgsCross.riscv64;

  # Builds a package named after the case whose postInstall runs the given
  # commands, and expects the build to exit with status 1 and the given message
  # in its log.  With cross, the package is built for a host platform whose
  # programs the build platform cannot execute.
  expectFailure =
    name:
    {
      message,
      postInstall ? "",
      program ? ''echo "foo $*"'',
      attrs ? { },
      cross ? false,
    }:
    testers.testBuildFailure' {
      drv = (if cross then pkgsHost.callPackage else callPackage) (
        { stdenvNoCC, generateShellCompletions }:
        stdenvNoCC.mkDerivation (
          {
            name = "generate-shell-completions-test-failure-${name}";
            __structuredAttrs = true;
            dontUnpack = true;
            nativeBuildInputs = [ generateShellCompletions ];
            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              printf '#!%s\n%s\n' ${stdenvNoCC.shell} ${lib.escapeShellArg program} > $out/bin/foo
              chmod +x $out/bin/foo
              runHook postInstall
            '';
            inherit postInstall;
            meta.mainProgram = "foo";
          }
          // attrs
        )
      ) { };
      expectedBuilderLogEntries = [ message ];
    };

  cases = lib.mapAttrs expectFailure {
    exit-status = {
      message = "generating bash completions failed";
      program = ''echo "foo $*"; exit 1'';
      postInstall = "generateShellCompletions -- completion {shell}";
    };
    same-script = {
      message = "generating fish completions printed the same script as for bash";
      program = "echo foo";
      postInstall = "generateShellCompletions -- completion {shell}";
    };
    # Fish first, so that the script for fish is the earlier one of the pair
    same-script-after-fish = {
      message = "generating zsh completions printed the same script as for fish";
      program = "echo foo";
      postInstall = "generateShellCompletions --shells 'fish zsh' -- completion {shell}";
    };
    duplicate-shell = {
      message = "shell bash is listed more than once";
      postInstall = "generateShellCompletions --shells 'bash bash' -- completion {shell}";
    };
    empty-output = {
      message = "generating bash completions printed nothing";
      program = "true";
      postInstall = "generateShellCompletions -- completion {shell}";
    };
    wrong-cmd = {
      message = "no executable named metal";
      postInstall = "generateShellCompletions --cmd metal -- completion {shell}";
    };
    cmd-path = {
      message = "--cmd expects a command name";
      postInstall = "generateShellCompletions --cmd bin/foo -- completion {shell}";
    };
    cross-wrong-cmd = {
      message = "no executable named metal";
      postInstall = "generateShellCompletions --cmd metal -- completion {shell}";
      cross = true;
    };
    cross-missing-placeholder = {
      message = "contain {shell}";
      postInstall = "generateShellCompletions -- completion bash";
      cross = true;
    };
    missing-placeholder = {
      message = "contain {shell}";
      postInstall = "generateShellCompletions -- completion bash";
    };
    unknown-option = {
      message = "unknown option --completions";
      postInstall = "generateShellCompletions --completions {shell}";
    };
    unsupported-shell = {
      message = "unsupported shell powershell";
      postInstall = "generateShellCompletions --shells 'bash powershell' -- completion {shell}";
    };
    missing-option-argument = {
      message = "--cmd expects an argument";
      postInstall = "generateShellCompletions --cmd";
    };
    empty-option-argument = {
      message = "--cmd expects an argument";
      postInstall = "generateShellCompletions --cmd '' -- completion {shell}";
    };
    program-missing = {
      message = "does not exist or is not executable";
      postInstall = "generateShellCompletions --program metal -- completion {shell}";
    };
    program-not-executable = {
      message = "does not exist or is not executable";
      postInstall = ''
        touch $out/bin/metal
        generateShellCompletions --program metal -- completion {shell}
      '';
    };
    bad-env = {
      message = "--env expects <name>=<value>";
      postInstall = "generateShellCompletions --env COMPLETE -- completion {shell}";
    };
    missing-program = {
      message = "set meta.mainProgram or pass --program";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs.meta = { };
    };
    attrs-missing-program = {
      message = "set meta.mainProgram or generateShellCompletionsProgram";
      attrs = {
        generateShellCompletionsArgs = [
          "completion"
          "{shell}"
        ];
        meta = { };
      };
    };
    never-ran = {
      message = "call generateShellCompletions outside a subshell, or set dontGenerateShellCompletions";
    };
    attrs-and-call = {
      message = "use either the attributes or calls";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs.generateShellCompletionsArgs = [
        "completion"
        "{shell}"
      ];
    };
    shells-attr-and-call = {
      message = "use either the attributes or calls";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs.generateShellCompletionsShells = [ "bash" ];
    };
    attribute-set-attr-and-call = {
      message = "use either the attributes or calls";
      postInstall = "generateShellCompletions -- completion {shell}";
      # Attribute set instead of a list, which still counts as set
      attrs.generateShellCompletionsShells.bash = true;
    };
    attrs-and-later-call = {
      message = "use either the attributes or calls";
      attrs = {
        generateShellCompletionsArgs = [
          "completion"
          "{shell}"
        ];
        postFixup = "generateShellCompletions --shells bash -- other";
      };
    };
    attrs-without-post-install = {
      message = "make sure that installPhase runs runHook postInstall";
      attrs = {
        generateShellCompletionsArgs = [
          "completion"
          "{shell}"
        ];
        # No runHook postInstall, so the attributes are never used
        installPhase = "mkdir -p $out";
      };
    };
    call-without-post-install = {
      message = "make sure that installPhase runs runHook postInstall";
      postInstall = "generateShellCompletions -- completion {shell}";
      # No runHook postInstall, so the call in postInstall never runs
      attrs.installPhase = "mkdir -p $out";
    };
    attrs-program-path-without-cmd = {
      message = "so set generateShellCompletionsCmd to that name";
      postInstall = ''
        mkdir -p $out/libexec
        cp $out/bin/foo $out/libexec/gen
      '';
      attrs = {
        generateShellCompletionsArgs = [ "{shell}" ];
        generateShellCompletionsProgram = "${placeholder "out"}/libexec/gen";
      };
    };
    install-failure = {
      message = "cannot overwrite directory";
      # Non-empty directory where the bash completion goes, which passes the
      # size check of installShellCompletion, so only errexit catches the
      # failing install
      postInstall = "mkdir -p $out/share/bash-completion/completions/foo.bash/x";
      attrs.generateShellCompletionsArgs = [
        "completion"
        "{shell}"
      ];
    };
    only-other-attrs = {
      message = "neither generateShellCompletionsArgs nor generateShellCompletionsEnv is set";
      attrs.generateShellCompletionsShells = [ "bash" ];
    };
    attrs-missing-placeholder = {
      message = "contain {shell}";
      attrs.generateShellCompletionsArgs = [
        "completion"
        "bash"
      ];
    };
    build-inputs = {
      message = "must be in nativeBuildInputs";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs = {
        nativeBuildInputs = [ ];
        buildInputs = [ generateShellCompletions ];
      };
    };
  };
in
linkFarmFromDrvs "generate-shell-completions-test-failures" (lib.attrValues cases)
