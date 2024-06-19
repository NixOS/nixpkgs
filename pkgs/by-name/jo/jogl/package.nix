{ lib
, stdenv
, fetchgit
, ant
, jdk11
, git
, xmlstarlet
, stripJavaArchivesHook
, xcbuild
, udev
, xorg
, mesa
, darwin
, coreutils
}:

let
  version = "2.4.0";

  gluegen-src = fetchgit {
    url = "git://jogamp.org/srv/scm/gluegen.git";
    rev = "v${version}";
    hash = "sha256-qQzq7v2vMFeia6gXaNHS3AbOp9HhDRgISp7P++CKErA=";
    fetchSubmodules = true;
  };
  jogl-src = fetchgit {
    url = "git://jogamp.org/srv/scm/jogl.git";
    rev = "v${version}";
    hash = "sha256-PHDq7uFEQfJ2P0eXPUi0DGFR1ob/n5a68otgzpFnfzQ=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation {
  pname = "jogl";
  inherit version;

  srcs = [ gluegen-src jogl-src ];
  sourceRoot = ".";

  unpackCmd = "cp -r $curSrc \${curSrc##*-}";

  postPatch = ''
    substituteInPlace gluegen/src/java/com/jogamp/common/util/IOUtil.java \
      --replace-fail '#!/bin/true' '#!${coreutils}/bin/true'
  ''
  # prevent looking for native libraries in /usr/lib
  + ''
    substituteInPlace jogl/make/build-*.xml \
      --replace-warn 'dir="''${TARGET_PLATFORM_USRLIBS}"' ""
  ''
  # force way to do disfunctional "ant -Dsetup.addNativeBroadcom=false" and disable dependency on raspberrypi drivers
  # if arm/aarch64 support will be added, this block might be commented out on those platforms
  # on x86 compiling with default "setup.addNativeBroadcom=true" leads to unsatisfied import "vc_dispmanx_resource_delete" in libnewt.so
  + ''
    xmlstarlet ed --inplace \
      --delete '//*[@if="setup.addNativeBroadcom"]' \
      jogl/make/build-newt.xml
  ''
  + lib.optionalString stdenv.isDarwin ''
    sed -i '/if="use.macos/d' gluegen/make/gluegen-cpptasks-base.xml
    rm -r jogl/oculusvr-sdk
  '';

  nativeBuildInputs = [
    ant
    jdk11
    git
    xmlstarlet
    stripJavaArchivesHook
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    udev
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXi
    xorg.libXt
    xorg.libXxf86vm
    xorg.libXrender
    mesa
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
    darwin.apple_sdk_11_0.frameworks.Cocoa
  ];

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

  meta = with lib; {
    description = "Java libraries for 3D Graphics, Multimedia and Processing";
    homepage = "https://jogamp.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
