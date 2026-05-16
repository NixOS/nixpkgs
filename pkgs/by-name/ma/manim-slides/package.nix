{ python3Packages }:
with python3Packages;
(toPythonApplication manim-slides).overridePythonAttrs (oldAttrs: {
  dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.pyqt6-full;
})
