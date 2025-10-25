{
  callPackage,
}:
callPackage ../libbluray/package.nix {
  withAACS = true;
  withBDplus = true;
  withJava = true;
}
