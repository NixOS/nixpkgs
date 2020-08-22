{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtsvg, qtdeclarative, qttools, qtgraphicaleffects, qtquickcontrols2, full
, libsecret, libGL, libpulseaudio, glib, wrapQtAppsHook, mkDerivation }:

let
  version = "1.3.3-1";

  description = ''
    An application that runs on your computer in the background and seamlessly encrypts
    and decrypts your mail as it enters and leaves your computer.

    To work, gnome-keyring service must be enabled.
  '';
in mkDerivation {
  pname = "protonmail-bridge";
  inherit version;

  src = fetchurl {
    url = "https://protonmail.com/download/protonmail-bridge_${version}_amd64.deb";
    sha256 = "182w20ag49xgr26z6zbl7yjzrsxim1dga439h7nm244aqw7g2raj";
  };

  sourceRoot = ".";

  unpackCmd = ''
    ar p "$src" data.tar.xz | tar xJ
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,share}

    cp -r usr/lib/protonmail/bridge/protonmail-bridge $out/lib
    cp -r usr/share $out

    ln -s $out/lib/protonmail-bridge $out/bin/protonmail-bridge
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtquickcontrols2
      qtgraphicaleffects
      qtmultimedia
      qtsvg
      qtdeclarative
      qttools
      libGL
      libsecret
      libpulseaudio
      glib
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      $out/lib/protonmail-bridge

    substituteInPlace $out/share/applications/protonmail-bridge.desktop \
      --replace "/usr/" "$out/" \
      --replace "Exec=protonmail-bridge" "Exec=$out/bin/protonmail-bridge"
  '';

  buildInputs = [ qtbase qtquickcontrols2 qtmultimedia qtgraphicaleffects qtdeclarative ];

  meta = with stdenv.lib; {
    homepage = "https://www.protonmail.com/bridge";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lightdiscord ];

    inherit description;
  };
}
