{
  python3,
  fetchFromGitHub,
}:

let
  python = python3.override {
    self = python3;
    packageOverrides = _: super: {
      amaranth = super.amaranth.overridePythonAttrs rec {
        version = "0.4.1";

        src = fetchFromGitHub {
          owner = "amaranth-lang";
          repo = "amaranth";
          rev = "refs/tags/v${version}";
          sha256 = "sha256-VMgycvxkphdpWIib7aZwh588En145RgYlG2Zfi6nnDo=";
        };

        postPatch = null;
      };
    };
  };
in

python.pkgs.toPythonApplication python.pkgs.cynthion
