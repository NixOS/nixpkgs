{
  dapl,
  graalvmPackages,
  stdenv,
  buildNativeImage ? true,
  graalvm ? graalvmPackages.graalvm-ce,
}:

dapl.override {
  inherit buildNativeImage;
  jre = graalvm;
  stdenvNoCC = stdenv;
}
