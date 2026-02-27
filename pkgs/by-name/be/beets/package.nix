{
  python3,
}:

let
  python = python3.override {
    self = python3;
    packageOverrides = self: super: {
      pyrate-limiter = super.pyrate-limiter_2;
    };
  };
in
python.pkgs.toPythonApplication python.pkgs.beets
