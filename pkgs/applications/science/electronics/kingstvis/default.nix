{ stdenv
, buildFHSUserEnv
, lib
, fetchurl
, glib
, xorg
, libGL
, zlib
, fontconfig
, freetype
, xkeyboard_config
, dbus
}:

let

  pkg = stdenv.mkDerivation (rec {
    pname = "kingstvis";
    version = "3.6.1";

    src = fetchurl {
      url = "http://res.kingst.site/kfs/KingstVIS_v3.6.1.tar.gz";
      sha256 = "sha256-WWLlUm7031E8v5EVobXpNo9sURh+S4aVfmhDlWjK7qA=";
    };

    dontBuild = true;
    installPhase = ''
      cp -R . $out
    '';
  });

in

buildFHSUserEnv {
  name = "kingstvis";

  targetPkgs = pkgs: (with pkgs; [
    glib
    xorg.libXext
    xorg.libX11
    libGL
    zlib
    xorg.libXi
    fontconfig
    freetype
    xorg.libXrender
    xorg.libSM
    xorg.libICE
    xorg.libxcb
    xkeyboard_config
    dbus
  ]);

  runScript = "${pkg.outPath}/KingstVIS";

  # usage:
  # services.udev.packages = [ pkgs.kingstvis ];
  extraInstallCommands = ''
    # Install udev rule
    install -Dvm644 ${pkg.outPath}/Driver/99-Kingst.rules  \
      $out/lib/udev/rules.d/99-Kingst.rules
  '';

  meta = {
    description = "Kingst Virtual Instruments Studio. Software for logic analyzers.";
    homepage = "http://www.qdkingst.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.luisdaranda ];
    platforms = [ "x86_64-linux" ];
  };
}
