{ lib
, stdenv
, fetchurl
, alsaLib
, autoPatchelfHook
, binutils-unwrapped
, gnutar
, libav_0_8
, libnotify
, libresample
, libusb1
, qt4
, rpmextract
, unzip
, xorg
, usersGroup ? "clickshare"  # for udev access rules
}:


# This fetches the latest firmware version that
# contains a linux-compatible client binary.
# Barco no longer supports linux, so updates are unlikely:
# https://www.barco.com/de/support/clickshare-csc-1/knowledge-base/KB1191


stdenv.mkDerivation rec {
  pname = "clickshare-csc1";
  version = "01.07.00.033";
  src = fetchurl {
    name = "clickshare-csc1-${version}.zip";
    url = https://www.barco.com/services/website/de/TdeFiles/Download?FileNumber=R33050020&TdeType=3&MajorVersion=01&MinorVersion=07&PatchVersion=00&BuildVersion=033;
    sha256 = "0h4jqidqvk4xkaky5bizi7ilz4qzl2mh68401j21y3djnzx09br3";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    binutils-unwrapped
    gnutar
    rpmextract
    unzip
  ];
  buildInputs = [
    alsaLib
    libav_0_8
    libnotify
    libresample
    libusb1
    qt4
    xorg.libX11
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXtst
  ];
  sourceRoot = ".";

  # The source consists of nested archives.
  # We extract them archive by archive.
  # If the filename contains version numbers,
  # we use a wildcard and check that there
  # is actually only one file matching.
  postUnpack =
    let
      rpmArch =
        if stdenv.hostPlatform.isx86_32 then "i386" else
        if stdenv.hostPlatform.isx86_64 then "x86_64" else
        throw "unsupported system: ${stdenv.hostPlatform.system}";
    in
      ''
        ls clickshare_baseunit_*.*_all.signed_release.ipk | wc --lines | xargs test 1 =
        tar --verbose --extract --one-top-level=dir1 < clickshare_baseunit_*.*_all.signed_release.ipk
        mkdir dir2
        ( cd dir2 ; ar xv ../dir1/firmware.ipk )
        tar --verbose --gzip --extract --one-top-level=dir3 --exclude='dev/*' < dir2/data.tar.gz
        ls dir3/clickshare/clickshare-*-*.${rpmArch}.rpm | wc --lines | xargs test 1 =
        mkdir dir4
        cd dir4
        rpmextract ../dir3/clickshare/clickshare-*-*.${rpmArch}.rpm
      '';

  installPhase = ''
    runHook preInstall
    mkdir --verbose --parents $out
    mv --verbose --target-directory=. usr/*
    rmdir --verbose usr
    cp --verbose --recursive --target-directory=$out *
    runHook postInstall
  '';

  # Default udev rule restricts access to the
  # clickshare USB dongle to the `wheel` group.
  # We replace it with the group
  # stated in the package arguments.
  # Also, we patch executable and icon paths in .desktop files.
  preFixup = ''
    substituteInPlace \
        $out/lib/udev/rules.d/99-clickshare.rules \
        --replace wheel ${usersGroup}
    substituteInPlace \
        $out/share/applications/clickshare.desktop \
        --replace Exec= Exec=$out/bin/ \
        --replace =/usr =$out
    substituteInPlace \
        $out/etc/xdg/autostart/clickshare-launcher.desktop \
        --replace =/usr =$out
  '';

  meta = {
    homepage = https://www.barco.com/de/support/clickshare-csc-1/drivers;
    downloadPage = https://www.barco.com/de/Support/software/R33050020;
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yarny ];
    description = "Linux driver/client for Barco ClickShare CSC-1";
    longDescription = ''
      Barco ClickShare is a wireless presentation system
      where a USB dongle transmits to a base station
      that is connected with a beamer.
      The USB dongle requires proprietary software that
      captures the screen and sends it to the dongle.
      This package provides the necessary software for Linux.
    '';
  };
}
