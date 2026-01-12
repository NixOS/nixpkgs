{
  lib,
  callPackage,
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
  meson,
  ninja,
  withJava ? false,
  jdk21_headless, # Newer JDK's depend on a release with a fix for https://code.videolan.org/videolan/libbluray/-/issues/46
  ant,
  stripJavaArchivesHook,
  withAACS ? false,
  libaacs,
  withBDplus ? false,
  libbdplus,
  withMetadata ? true,
  libxml2,
  withFonts ? true,
  freetype,
  libbluray-full, # Used for tests
}:

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbluray";
  version = "1.4.0";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-d5N7rwfq3aSysxHPOvTFAmnS6jFlBB9YQ9lkdsTJJ3c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withJava [
    jdk21_headless
    ant
    stripJavaArchivesHook
  ];

  buildInputs = [
    fontconfig
  ]
  ++ lib.optional withMetadata libxml2
  ++ lib.optional withFonts freetype;

  propagatedBuildInputs = lib.optional withAACS libaacs;

  env.JAVA_HOME = lib.optionalString withJava jdk21_headless.home; # Fails at runtime without this
  env.NIX_LDFLAGS =
    lib.optionalString withAACS "-L${libaacs}/lib -laacs"
    + lib.optionalString withBDplus " -L${libbdplus}/lib -lbdplus";

  mesonFlags =
    lib.optional (!withJava) "-Dbdj_jar=disabled"
    ++ lib.optional (!withMetadata) "-dlibxml2=disabled"
    ++ lib.optional (!withFonts) "-Dfreetype=disabled";

  meta = {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };

  passthru = {
    tests = {
      # Verify the "full" package when verifying changes to this package
      inherit libbluray-full;
    };
  };
}
