{
  python3Packages,
}:
(python3Packages.toPythonApplication python3Packages.manim-slides).overridePythonAttrs (oldAttrs: {
  dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.pyqt6-full;
})
