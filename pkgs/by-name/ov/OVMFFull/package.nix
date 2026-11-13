{
  OVMF,
  stdenv,
}:

OVMF.override {
  secureBoot = true;
  httpSupport = true;
  tpmSupport = true;
  tlsSupport = true;
  msVarsTemplate = stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64;
}
