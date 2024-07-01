{ python3Packages }:
(python3Packages.toPythonApplication python3Packages.swh-core)
// {
  meta = python3Packages.swh-core.meta // {
    mainProgram = "swh";
  };
}
