{ pkgs, python }:

self: super: {
  "pytest-runner" = python.overrideDerivation super."pytest-runner" (old: {
    buildInputs = old.buildInputs ++ [ self."setuptools-scm" ];
  });
  "grandalf" = python.overrideDerivation super."grandalf" (old: {
    buildInputs = old.buildInputs ++ [ self."pytest-runner" ];
  });
  "inflect" = python.overrideDerivation super."inflect" (old: {
    buildInputs = old.buildInputs ++ [ self."setuptools-scm" ];
  });
}
