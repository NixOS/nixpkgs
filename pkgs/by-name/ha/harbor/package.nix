{
  python3Packages,

  # features
  computer1Support ? false,
  ec2Support ? false,
  gkeSupport ? false,
  wandbSupport ? false,

  langsmithSupport ? false,
  atif2otelSupport ? false,
}:

python3Packages.toPythonApplication (
  python3Packages.harbor.override {
    inherit
      computer1Support
      ec2Support
      gkeSupport
      wandbSupport
      langsmithSupport
      atif2otelSupport
      ;
  }
)
