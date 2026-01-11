{
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      av = self.av_13;
    }
  );
in
pythonPackages.toPythonApplication pythonPackages.manim
