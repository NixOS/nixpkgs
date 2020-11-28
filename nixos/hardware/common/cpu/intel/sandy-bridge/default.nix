{
  imports = [ ../. ];

  # Enables RC6, RC6p and RC6pp.
  # Last two are only available on Sandy Bridge CPUs (circa 2011).
  boot.kernelParams = [
    "i915.enable_rc6=7"
  ];
}
