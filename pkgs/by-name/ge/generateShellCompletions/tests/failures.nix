{
  lib,
  runCommand,
  stdenvNoCC,
  testers,
  generateShellCompletions,
}:

let
  # Builds a package whose postInstall runs the given commands, and expects the
  # build to fail with the given message in its log.
  expectFailure =
    {
      message,
      postInstall,
      program ? ''echo "foo $*"'',
      attrs ? { },
    }:
    {
      inherit message;
      failure = testers.testBuildFailure (
        stdenvNoCC.mkDerivation (
          {
            name = "generate-shell-completions-test-failure";
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
      );
    };

  cases = {
    exit-status = expectFailure {
      message = "generating bash completions failed";
      program = ''echo "foo $*"; exit 1'';
      postInstall = "generateShellCompletions -- completion {shell}";
    };
    empty-output = expectFailure {
      message = "does not exist or has zero size";
      program = "true";
      postInstall = "generateShellCompletions -- completion {shell}";
    };
    wrong-cmd = expectFailure {
      message = "no executable named metal";
      postInstall = "generateShellCompletions --cmd metal -- completion {shell}";
    };
    missing-placeholder = expectFailure {
      message = "contain {shell}";
      postInstall = "generateShellCompletions -- completion bash";
    };
    unknown-option = expectFailure {
      message = "unknown option --completions";
      postInstall = "generateShellCompletions --completions {shell}";
    };
    unsupported-shell = expectFailure {
      message = "unsupported shell powershell";
      postInstall = "generateShellCompletions --shells 'bash powershell' -- completion {shell}";
    };
    bad-env = expectFailure {
      message = "--env expects <name>=<value>";
      postInstall = "generateShellCompletions --env COMPLETE -- completion {shell}";
    };
    missing-program = expectFailure {
      message = "set meta.mainProgram or pass --program";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs.meta = { };
    };
    build-inputs = expectFailure {
      message = "must be in nativeBuildInputs";
      postInstall = "generateShellCompletions -- completion {shell}";
      attrs = {
        nativeBuildInputs = [ ];
        buildInputs = [ generateShellCompletions ];
      };
    };
  };
in
runCommand "generate-shell-completions-test-failures" { } ''
  ${lib.concatMapAttrsStringSep "\n" (name: case: ''
    if ! grep -qF -e ${lib.escapeShellArg case.message} ${case.failure}/testBuildFailure.log; then
      echo ${lib.escapeShellArg "${name}: expected the build log to contain: ${case.message}"}
      exit 1
    fi
  '') cases}
  touch $out
''
