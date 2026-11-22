{
  dapl,
  graalvmPackages,
}:

dapl.override {
  buildNativeImage = true;
  jdk = graalvmPackages.graalvm-ce;
}
