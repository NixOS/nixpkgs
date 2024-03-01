{ lib, stdenvNoCC, bubblewrap, buildFHSEnv, fakeroot, fetchurl, glibc, rsync }:

let
  fhsEnv = buildFHSEnv {
    name = "mplab-x-build-fhs-env";
    targetPkgs = pkgs: [ fakeroot glibc ];
  };

in stdenvNoCC.mkDerivation rec {
  pname = "mplab-x-unwrapped";
  version = "6.20";

  src = fetchurl {
    url =
      "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/MPLABX-v${version}-linux-installer.tar";
    hash = "sha256-zs77CsuKFUCGYwUiv4ZZLm8HZLskxm3zP8HoGMUHdWA=";

    # The Microchip server requires this Referer to allow the download.
    curlOptsList = [
      "--referer"
      "https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide"
    ];
  };

  nativeBuildInputs = [ bubblewrap rsync ];

  unpackPhase = ''
    runHook preUnpack

    tar xf $src MPLABX-v${version}-linux-installer.sh
    sh MPLABX-v${version}-linux-installer.sh \
      --tar xf ./MPLABX-v${version}-linux-installer.run

    runHook postUnpack
  '';
  buildPhase = ''
    runHook preBuild

    rsync -a ${fhsEnv.fhsenv}/ chroot/
    find chroot -type d -exec chmod 755 {} \;
    echo "root:x:0:0:root:/root:/bin/bash" > chroot/etc/passwd
    echo "root:x:0:root" > chroot/etc/group
    mkdir -p chroot/tmp/home

    bwrap \
      --bind chroot / \
      --ro-bind /nix /nix \
      --ro-bind MPLABX-v${version}-linux-installer.run /installer \
      --setenv HOME /tmp/home \
      -- /bin/fakeroot /installer --mode unattended

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc $out/usr/share
    cp -r chroot/etc/.mplab_ide $out/etc/
    cp -r chroot/etc/udev $out/etc/
    cp -r chroot/usr/share/applications chroot/usr/share/icons $out/usr/share/
    cp -r chroot/opt $out/

    runHook postInstall
  '';
  dontFixup = true;

  passthru = { inherit fhsEnv; };

  meta = with lib; {
    homepage =
      "https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide";
    description =
      "An expandable, highly configurable software program that incorporates powerful tools to help you discover, configure, develop, debug and qualify embedded designs for most of Microchip's microcontrollers and digital signal controllers.";
    license = licenses.unfree;
    maintainers = with maintainers; [ remexre ];
    platforms = [ "x86_64-linux" ];
  };
}
