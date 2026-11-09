{
  lib,
  stdenv,
  fetchgit,
  fetchpatch2,
  ant,
  jdk17,
  xmlstarlet,
  stripJavaArchivesHook,
  udev,
  libxxf86vm,
  libxt,
  libxrender,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libgbm,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jogl";
  version = "2.6.0";

  srcs = [
    (fetchgit {
      url = "git://jogamp.org/srv/scm/gluegen.git";
      rev = "v${finalAttrs.version}";
      hash = "sha256-Bvl2vZ8EjnGdG0ZVbI1YB0nfhT8ZedhRDdrjRFVMm34=";
      fetchSubmodules = true;
    })
    (fetchgit {
      url = "git://jogamp.org/srv/scm/jogl.git";
      rev = "v${finalAttrs.version}";
      hash = "sha256-0g8rvDLJkVIEJ7Oc4F7Aot+t3/dIme6RGEamdte8qt8=";
      fetchSubmodules = true;
    })
  ];
  sourceRoot = ".";

  unpackCmd = "cp -r $curSrc \${curSrc##*-}";

  patches = [
    (fetchpatch2 {
      name = "fix-gcc-issue.patch";
      url = "https://jogamp.org/cgit/jogl.git/patch/?id=d901bd308cc82e189344200cee28a79a808683c9";
      hash = "sha256-pVvCY1AA75zXQ2/xxp3jyRTAbvnppV6MsJVmdZbLNJE=";
      stripLen = 1;
      extraPrefix = "jogl/";
    })
    ./zero-width-space-fix.patch
  ];

  postPatch = ''
    substituteInPlace gluegen/src/java/com/jogamp/common/util/IOUtil.java \
      --replace-fail 'getExeTestShellCodeUnix("/usr/bin/true")' 'getExeTestShellCodeUnix("${coreutils}/bin/true")'
  ''
  # prevent looking for native libraries in /usr/lib
  + ''
    substituteInPlace jogl/make/build-*.xml \
      --replace-warn 'dir="''${TARGET_PLATFORM_USRLIBS}"' ""
  ''
  # force way to do dysfunctional "ant -Dsetup.addNativeBroadcom=false" and disable dependency on raspberrypi drivers
  # if arm/aarch64 support will be added, this block might be commented out on those platforms
  # on x86 compiling with default "setup.addNativeBroadcom=true" leads to unsatisfied import "vc_dispmanx_resource_delete" in libnewt.so
  + ''
    xmlstarlet ed --inplace \
      --delete '//*[@if="setup.addNativeBroadcom"]' \
      jogl/make/build-newt.xml
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '/if="use.macos/d' gluegen/make/gluegen-cpptasks-base.xml
    rm -r jogl/oculusvr-sdk
  ''
  # clock_gettime and CLOCK_MONOTONIC/CLOCK_REALTIME are only available since
  # macOS 10.12, while the build files hardcode a 10.7 deployment target.
  # With -Werror,-Wunguarded-availability the native build then fails.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace gluegen/make/gluegen-cpptasks-base.xml \
      --replace-fail '-mmacosx-version-min=10.7' '-mmacosx-version-min=10.12'
  ''
  # gluegen's default ant target runs 'dump.localinfo', which executes a junit
  # test case extending SingletonJunitCase. That class grabs a singleton lock by
  # binding 127.0.0.1:59999, which is blocked in the sandbox, and then retries
  # for 15 minutes, hanging the build. The lock only serves to serialize
  # concurrently running test JVMs, which never happens here; disable it.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace gluegen/src/junit/com/jogamp/junit/util/SingletonJunitCase.java \
      --replace-fail 'private static boolean enabled = true;' 'private static boolean enabled = false;'
  '';

  nativeBuildInputs = [
    ant
    jdk17
    xmlstarlet
    stripJavaArchivesHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
    libx11
    libxrandr
    libxcursor
    libxi
    libxt
    libxxf86vm
    libxrender
    libgbm
  ];

  strictDeps = true;

  env = {
    SOURCE_LEVEL = "1.8";
    TARGET_LEVEL = "1.8";
    TARGET_RT_JAR = "null.jar";
    # error: incompatible pointer to integer conversion returning 'GLhandleARB' (aka 'void *') from a function with result type 'jlong' (aka 'long long')
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";
  };

  buildPhase = ''
    runHook preBuild

    for f in gluegen jogl; do
      pushd $f/make
      ant
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp -v $NIX_BUILD_TOP/gluegen/build/gluegen-rt{,-natives-linux-*}.jar $out/share/java/
    cp -v $NIX_BUILD_TOP/jogl/build/jar/jogl-all{,-natives-linux-*}.jar  $out/share/java/
    cp -v $NIX_BUILD_TOP/jogl/build/nativewindow/nativewindow{,-awt,-natives-linux-*,-os-drm,-os-x11}.jar  $out/share/java/

    runHook postInstall
  '';

  meta = {
    description = "Java libraries for 3D Graphics, Multimedia and Processing";
    homepage = "https://jogamp.org/";
    changelog = "https://jogamp.org/deployment/jogamp-current/archive/ChangeLogs/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
