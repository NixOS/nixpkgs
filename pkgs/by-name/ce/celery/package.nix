{
  fetchFromGitHub,
  python3Packages,
}:

let
  pythonPackages = python3Packages.override {
    overrides = self: super: {
      click = super.click.overridePythonAttrs rec {
        version = "8.1.8";
        src = fetchFromGitHub {
          owner = "pallets";
          repo = "click";
          tag = version;
          hash = "sha256-pAAqf8jZbDfVZUoltwIFpov/1ys6HSYMyw3WV2qcE/M=";
        };
      };
    };
  };
in
with pythonPackages;
toPythonApplication (celery.override { withAmqpRepl = true; })
