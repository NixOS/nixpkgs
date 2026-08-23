{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
  meson,
  ninja,
  withJava ? false,
  jdk21,
  jre21_minimal, # Newer JDK's depend on a release with a fix for https://code.videolan.org/videolan/libbluray/-/issues/46
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

let
  jre = jre21_minimal.override {
    modules = [
      "java.base"
      "java.datatransfer"
      "java.desktop"
      "java.rmi"
      "java.xml"
    ];
    jdk = jdk21;
  };
in
stdenv.mkDerivation rec {
  pname = "libbluray";
  version = "1.4.1";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/libbluray-${version}.tar.xz";
    hash = "sha256-drXcQAl/KNyk67AJyY7VEyGyknRT91zHLPdKzQm59Ek=";
  };

  postPatch =
    lib.optionalString withAACS ''
      substituteInPlace src/libbluray/disc/aacs.c --replace-fail 'getenv("LIBAACS_PATH")' '"${libaacs}/lib/libaacs"'
    ''
    + lib.optionalString withBDplus ''
      substituteInPlace src/libbluray/disc/bdplus.c --replace-fail 'getenv("LIBBDPLUS_PATH")' '"${libbdplus}/lib/libbdplus"'
    '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withJava [
    jdk21
    ant
    stripJavaArchivesHook
  ];

  buildInputs = [
    fontconfig
  ]
  ++ lib.optional withMetadata libxml2
  ++ lib.optional withFonts freetype;

  propagatedBuildInputs = lib.optional withAACS libaacs;

  env.NIX_LDFLAGS =
    lib.optionalString withAACS "-L${libaacs}/lib -laacs"
    + lib.optionalString withBDplus " -L${libbdplus}/lib -lbdplus";

  mesonFlags =
    lib.optional (!withJava) "-Dbdj_jar=disabled"
    ++ lib.optional withJava "-Djdk_home=${jre.home}"
    ++ lib.optional (!withMetadata) "-dlibxml2=disabled"
    ++ lib.optional (!withFonts) "-Dfreetype=disabled";

  passthru = {
    tests = {
      # Verify the "full" package when verifying changes to this package
      inherit libbluray-full;
    };
  };

  meta = {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    longDescription = "See <https://wiki.archlinux.org/title/Blu-ray> how to use";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.amarshall ];
    platforms = lib.platforms.unix;
  };
}
