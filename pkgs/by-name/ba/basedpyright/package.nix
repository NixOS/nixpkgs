{
  lib,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  docify,
  testers,
  writeText,
  jq,
  basedpyright,
  pkg-config,
  libsecret,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "basedpyright";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "refs/tags/v${version}";
    hash = "sha256-RwckZqEL5U60XSYul74p9Ezg+N8FrnLkRFpdxIa7/34=";
  };

  npmDepsHash = "sha256-hCZ68sLpQs/7SYVf3pMAHfstRm1C/d80j8fESIFdhnw=";
  npmWorkspace = "packages/pyright";

  preBuild = ''
    # Build the docstubs
    cp -r packages/pyright-internal/typeshed-fallback docstubs
    docify docstubs/stdlib --builtins-only --in-place
  '';

  nativeBuildInputs = [
    docify
    pkg-config
  ];

  buildInputs = [ libsecret ];

  postInstall = ''
    mv "$out/bin/pyright" "$out/bin/basedpyright"
    mv "$out/bin/pyright-langserver" "$out/bin/basedpyright-langserver"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      # We are expecting 4 errors. Any other amount would indicate not working
      # stub files, for instance.
      simple = testers.testEqualContents {
        assertion = "simple type checking";
        expected = writeText "expected" ''
          4
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [
                jq
                basedpyright
              ];
              base = writeText "test.py" ''
                import sys
                from time import tzset

                def print_string(a_string: str):
                    a_string += 42
                    print(a_string)

                if sys.platform == "win32":
                    print_string(69)
                    this_function_does_not_exist("nice!")
                else:
                    result_of_tzset_is_None: str = tzset()
              '';
              configFile = writeText "pyproject.toml" ''
                [tool.pyright]
                typeCheckingMode = "strict"
              '';
            }
            ''
              (basedpyright --outputjson $base || true) | jq -r .summary.errorCount > $out
            '';
      };
    };
  };

  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${version}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [ kiike ];
  };
}
