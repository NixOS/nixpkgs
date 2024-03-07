{ stdenv
, fetchurl
, dpkg
, lib
, glib
, nss
, nspr
, at-spi2-atk
, cups
, dbus
, libdrm
, gtk3
, pango
, cairo
, xorg
, libxkbcommon
, mesa
, expat
, alsa-lib
, buildFHSEnv
}:

let
  pname = "typora";
  version = "1.7.6";
  src = fetchurl {
    url = "https://download.typora.io/linux/typora_${version}_amd64.deb";
    hash = "sha256-o91elUN8sFlzVfIQj29amsiUdSBjZc51tLCO+Qfar6c=";
  };

  typoraBase = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [ dpkg ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      mv usr/share $out
      ln -s $out/share/typora/Typora $out/bin/Typora
      runHook postInstall
    '';
  };

  typoraFHS = buildFHSEnv {
    name = "typora-fhs";
    targetPkgs = pkgs: (with pkgs; [
      typoraBase
      udev
      alsa-lib
      glib
      nss
      nspr
      atk
      cups
      dbus
      gtk3
      libdrm
      pango
      cairo
      mesa
      expat
      libxkbcommon
    ]) ++ (with pkgs.xorg; [
      libX11
      libXcursor
      libXrandr
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libxcb
    ]);
    runScript = ''
      Typora $*
    '';
  };

in stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${typoraFHS}/bin/typora-fhs $out/bin/typora
    ln -s ${typoraBase}/share/ $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "A markdown editor, a markdown reader";
    homepage = "https://typora.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ npulidomateo ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "typora";
  };
}
