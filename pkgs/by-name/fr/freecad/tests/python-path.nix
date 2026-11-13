{
  freecad,
  runCommand,
}:
# Check that things such as argument parsing still work correctly with
# the above PYTHONPATH patch. Previously the patch used above changed
# the `PyConfig_InitIsolatedConfig` to `PyConfig_InitPythonConfig`,
# which caused the built-in interpreter to attempt (and fail) to doubly
# parse argv. This should catch if that ever regresses and also ensures
# that PYTHONPATH is still respected enough for the FreeCAD console to
# successfully run and check that it was included in `sys.path`.
runCommand "freecad-test-console"
  {
    nativeBuildInputs = [ freecad ];
  }
  ''
    HOME="$(mktemp -d)" PYTHONPATH="$(pwd)/test" FreeCADCmd --log-file $out -c "if not '$(pwd)/test' in sys.path: sys.exit(1)" </dev/null
  ''
