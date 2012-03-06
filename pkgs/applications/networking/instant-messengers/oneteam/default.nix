x@{builderDefsPackage
  , fetchgit, perl, xulrunner, cmake, perlPackages, zip, unzip, pkgconfig
  , pulseaudio, gtkLibs, pixman, nspr, nss, libXScrnSaver, scrnsaverproto
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchgit" "perlPackages" "gtkLibs"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames)) ++ [
      a.perlPackages.SubName a.gtkLibs.gtk a.gtkLibs.glib
    ];
  sourceInfo = rec {
    baseName="oneteam";
    version="git-head";
    name="${baseName}-${version}";
    url="git://git.process-one.net/oneteam/oneteam.git";
    rev="066cd861ea4436bbe363f032c58a746a1cac7498";
    hash="972310d6ef20db7dc749d7d935aa50889afe2004db2a07409830e09ef639f30a";
    method="fetchgit";
  };
in
rec {
  srcDrv = a.fetchgit {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.rev;
  };

  src=srcDrv + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["goComponents" "setVars" "fixComponents" "doCmake" 
    "doMakeInstall" "goBack" "buildApp" "doDeploy"];

  fixComponents = a.fullDepEntry ''
    sed -e '1i#include <netinet/in.h>' -i src/rtp/otRTPDecoder.cpp src/rtp/otRTPEncoder.cpp
  '' ["minInit" "doUnpack"];

  setVars=a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr}/include/nspr"
  '';

  cmakeBuildDir="cmake-build";
  cmakeFlags=["-D XPCOM_GECKO_SDK=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"];

  goComponents=a.fullDepEntry "cd src/components" ["doUnpack"];
  goBack=a.noDepEntry "cd ../../..";

  buildApp=a.fullDepEntry ''
    perl build.pl XULAPP 1
  '' ["addInputs"];

  doDeploy = a.fullDepEntry ''
    TARGET_DIR="$out/share/oneteam/app"
    BUILD_DIR="$PWD"
    mkdir -p "$TARGET_DIR"
    cd "$TARGET_DIR"
    unzip "$BUILD_DIR/oneteam.xulapp"
    mkdir -p "$out/bin"
    echo "#! ${a.stdenv.shell}" > "$out/bin/oneteam"
    echo "\"${xulrunner}/bin/xulrunner\" \"$TARGET_DIR/application.ini\"" > "$out/bin/oneteam"
    chmod a+x "$out/bin/oneteam"
    mkdir -p "$out/share/doc"
    cp -r "$BUILD_DIR/docs" "$out/share/doc/oneteam"
  '' ["defEnsureDir"];

  meta = {
    description = "An XMPP client";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
    homepage="http://oneteam.im";
  };
  passthru = {
    updateInfo = {
      downloadPage = "git://git.process-one.net/oneteam/oneteam.git";
    };
  };
}) x

