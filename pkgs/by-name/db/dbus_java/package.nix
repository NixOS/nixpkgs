{
  lib,
  stdenv,
  fetchurl,
  gettext,
  jdk8,
  libmatthew_java,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-java";
  version = "2.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus-java/dbus-java-${finalAttrs.version}.tar.gz";
    sha256 = "0cyaxd8x6sxmi6pklkkx45j311a6w51fxl4jc5j3inc4cailwh5y";
  };

  env = {
    JAVA_HOME = jdk8;
    JAVA = "${jdk8}/bin/java";
    PREFIX = "\${out}";
    JAVAUNIXLIBDIR = "${libmatthew_java}/lib/jni";
    JAVAUNIXJARDIR = "${libmatthew_java}/share/java";
  };

  nativeBuildInputs = [
    gettext
    jdk8
  ];

  # I'm too lazy to build the documentation
  buildFlags = [ "bin" ];
  installTargets = [ "install-bin" ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.afl21;
    homepage = "https://dbus.freedesktop.org/doc/dbus-java/";
  };
})
