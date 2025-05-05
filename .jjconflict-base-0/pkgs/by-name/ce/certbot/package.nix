{
  fetchFromGitHub,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
    };
  };
in
with python.pkgs;
toPythonApplication certbot
