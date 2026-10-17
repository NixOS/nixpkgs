{
  lib,
  python3Packages,
  gh,
  gitMinimal,
  gittuf,
  zizmor,
}:

let
  inherit (python3Packages) darnit-core;

  testPlugins = [
    "darnit-csl"
    "darnit-example"
    "darnit-hello"
    "darnit-testchecks"
  ];

  buildTestPlugin =
    pname:
    python3Packages.buildPythonPackage {
      inherit pname;
      inherit (darnit-core) src;
      version = "0.1.0";
      pyproject = true;

      sourceRoot = "${darnit-core.src.name}/packages/${pname}";

      build-system = [ python3Packages.hatchling ];

      dependencies = [ darnit-core ];
    };
in
python3Packages.buildPythonApplication {
  pname = "darnit";
  inherit (darnit-core) version src;
  pyproject = true;
  __structuredAttrs = true;

  # Expose the CLI from the meta-package so that the wrapper can see the
  # bundled plugins
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '[project.urls]' $'[project.scripts]\ndarnit = "darnit.cli:main"\n\n[project.urls]'
  '';

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    darnit-baseline
    darnit-core
    darnit-gittuf
    darnit-reproducibility
  ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      gh
      gitMinimal
      gittuf
      zizmor
    ])
  ];

  nativeCheckInputs = [
    gitMinimal
  ]
  ++ map buildTestPlugin testPlugins
  ++ (with python3Packages; [
    jsonschema
    pytest-asyncio
    pytestCheckHook
    syrupy
  ]);

  preCheck = ''
    export HOME=$(mktemp -d)
  ''
  # Test plugins locate their framework TOML relative to the source tree
  + lib.concatMapStrings (pname: ''
    export PYTHONPATH="$PWD/packages/${pname}/src:$PYTHONPATH"
  '') testPlugins;

  disabledTestPaths = [
    # Requires skills-ref, which is not packaged
    "tests/darnit/test_skills_spec.py"
    # Runs linters over the source tree
    "tests/test_lint.py"
    # Invoke the CLI through `uv run`
    "tests/packaging/test_wheel_install_config.py"
    "tests/test_main.py"
  ];

  disabledTests = [
    # Invoke the CLI through `uv run`
    "test_help_lists_harness_subcommand"
    "test_regenerated_output_matches_prefeature_baseline"
    # Downloads the SARIF schema
    "test_sarif_"
    # The mock MCP server subprocess runs with a filtered environment that
    # drops PYTHONPATH, so it cannot import its dependencies
    "test_arg_substitution"
    "test_fail_when_expr_false"
    "test_pass_evaluates_expr_over_result"
    "test_pool_survives_captured_sys_stderr"
    "test_progress_log_line_emitted"
    "test_teardown_on_success_path"
    "test_tool_side_error_produces_error_no_broken"
    "test_tool_timeout_produces_error_marks_broken"
    "test_trusted_publisher_absent_label_is_operator_trusted_path"
    "test_verification_success_trust_label"
  ];

  pythonImportsCheck = [
    "darnit"
    "darnit_baseline"
    "darnit_gittuf"
    "darnit_reproducibility"
  ];

  meta = {
    inherit (darnit-core.meta)
      homepage
      changelog
      license
      maintainers
      mainProgram
      ;
    description = "Pluggable compliance audit framework";
  };
}
