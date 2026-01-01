{
  lib,
<<<<<<< HEAD
  callPackage,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
<<<<<<< HEAD
  meson,
  ninja,
  withJava ? false,
  jdk21_headless, # Newer JDK's depend on a release with a fix for https://code.videolan.org/videolan/libbluray/-/issues/46
=======
  autoreconfHook,
  withJava ? false,
  jdk17,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  libbluray-full, # Used for tests
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbluray";
<<<<<<< HEAD
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
=======
  version = "1.3.4";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-R4/9aKD13ejvbKmJt/A1taCiLFmRQuXNP/ewO76+Xys=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ]
  ++ lib.optionals withJava [
    jdk17
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ant
    stripJavaArchivesHook
  ];

  buildInputs = [
    fontconfig
  ]
  ++ lib.optional withMetadata libxml2
  ++ lib.optional withFonts freetype;

  propagatedBuildInputs = lib.optional withAACS libaacs;

<<<<<<< HEAD
  env.JAVA_HOME = lib.optionalString withJava jdk21_headless.home; # Fails at runtime without this
=======
  env.JAVA_HOME = lib.optionalString withJava jdk17.home; # Fails at runtime without this
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  env.NIX_LDFLAGS =
    lib.optionalString withAACS "-L${libaacs}/lib -laacs"
    + lib.optionalString withBDplus " -L${libbdplus}/lib -lbdplus";

<<<<<<< HEAD
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
=======
  configureFlags =
    lib.optional (!withJava) "--disable-bdjava-jar"
    ++ lib.optional (!withMetadata) "--without-libxml2"
    ++ lib.optional (!withFonts) "--without-freetype";

  meta = with lib; {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
