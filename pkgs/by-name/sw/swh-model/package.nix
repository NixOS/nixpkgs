{ python3Packages }:
(python3Packages.toPythonApplication python3Packages.swh-model)
// {
  meta = python3Packages.swh-model.meta // {
    mainProgram = "swh.model";
  };
}
