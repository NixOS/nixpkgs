{
  lfortran,
  test-drive,
  toml-f,
}:

# Build toml-f and its test-drive dependency with LFortran in place of
# gfortran, and run toml-f's test suite. Meson doesn't know LFortran, so these
# builds use CMake.
let
  withLFortran =
    drv:
    drv.overrideAttrs (old: {
      pname = "${old.pname}-lfortran";
      # Fortran 2003 reallocation on assignment is opt-in in LFortran.
      env = old.env or { } // {
        FFLAGS = "--realloc-lhs-arrays";
      };
    });

  test-drive' = withLFortran (
    test-drive.override {
      gfortran = lfortran;
      buildType = "cmake";
    }
  );
in
(withLFortran (
  toml-f.override {
    gfortran = lfortran;
    buildType = "cmake";
    test-drive = test-drive';
  }
)).overrideAttrs
  {
    doCheck = true;
  }
