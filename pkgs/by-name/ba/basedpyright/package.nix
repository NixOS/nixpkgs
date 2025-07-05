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
  version = "1.29.5";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    tag = "v${version}";
    hash = "sha256-fD7A37G1kr7sWfwI8GXOm1cOlpnTSE9tN/WzotM8BeQ=";
  };

  npmDepsHash = "sha256-aJte4ApeXJQ9EYn87Uo+Xx7s+wi80I1JsZHeqklHGs4=";
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
    # Remove dangling symlinks created during installation (remove -delete to just see the files, or -print '%l\n' to see the target
    find -L $out -type l -print -delete
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${src.tag}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [
      kiike
      misilelab
    ];
  };
}
