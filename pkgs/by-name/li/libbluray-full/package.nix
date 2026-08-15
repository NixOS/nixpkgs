{
  lib,
  stdenv,
  jdk21,
  libbluray,
}:
libbluray.override {
  withAACS = true;
  withBDplus = true;
  withJava = lib.meta.availableOn stdenv.buildPlatform jdk21;
}
