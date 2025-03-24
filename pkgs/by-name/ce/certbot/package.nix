{
  fetchFromGitHub,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      josepy = super.josepy.overridePythonAttrs (old: rec {
        version = "1.15.0";
        src = fetchFromGitHub {
          owner = "certbot";
          repo = "josepy";
          tag = "v${version}";
          hash = "sha256-fK4JHDP9eKZf2WO+CqRdEjGwJg/WNLvoxiVrb5xQxRc=";
        };
        dependencies = with self; [
          pyopenssl
          cryptography
        ];
      });
    };
  };
in
with python.pkgs;
toPythonApplication certbot
