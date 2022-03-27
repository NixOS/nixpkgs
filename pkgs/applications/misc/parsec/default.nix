{ stdenv
, lib
, buildFHSUserEnv
, parsecDrv ? null
, dpkg
, fetchurl
}:

let
  parsecDrvUsed = if parsecDrv != null then parsecDrv else stdenv.mkDerivation rec {
    name = "parsec-extracted";
    src = fetchurl {
      url = "https://builds.parsecgaming.com/package/parsec-linux.deb"; # Can't seem to find a link to a specific version, hopefully this wont change invalidating the derivation.
      sha256 = "1hfdzjd8qiksv336m4s4ban004vhv00cv2j461gc6zrp37s0fwhc";
    };

    unpackPhase = "dpkg-deb -x ${src} .";

    nativeBuildInputs = [
      dpkg
    ];

    installPhase = ''
      mkdir $out
      cp -r ./usr/* $out
    '';
  };
  fhs = buildFHSUserEnv {
    name = "parsecd";

    targetPkgs = pkgs: with pkgs; [
      alsaLib
      dbus
      libGL
      libglvnd
      libpulseaudio
      libva.out
      openssl
      udev
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
    ];
    runScript = "${parsecDrvUsed}/bin/parsecd";
  };
in stdenv.mkDerivation {
  pname = "parsec";
  version = "1.0"; # Can't seem to find versioning upstream?

  dontUnpack = true;

  installPhase = ''
    mkdir $out/{share,bin} -p
    cp -r ${parsecDrvUsed}/share/{applications,icons} $out/share
    ln -s ${fhs}/bin/parsecd $out/bin/parsecd
  '';
  meta = with lib; {
    homepage = "https://parsecgaming.com/";
    description = "Remote streaming service client";
    license = licenses.unfree;
    maintainers = with maintainers; [ lucasew ];
    platforms = platforms.linux;
  };
}
